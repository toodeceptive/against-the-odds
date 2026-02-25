#!/bin/sh
# Generate infra/STRUCTURAL_STATE.json and sign it.
# Run locally after structural changes; never in CI.
# Use this on Unix or Git Bash on Windows (avoids ssh-keygen stdin hang on native Windows).
set -e
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
INFRA="$ROOT/infra"
mkdir -p "$INFRA"

FILES="AGENTS.md CODEOWNERS docs/OWNERSHIP_REGISTRY.md docs/SSOT_ATO.md docs/VERSION_POLICY.md .github/workflows/ci.yml"
FILES_SORTED="$(echo $FILES | tr ' ' '\n' | sort)"

# Build files object
files_json=""
for f in $FILES_SORTED; do
  if [ -f "$ROOT/$f" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
      hash="$(sha256sum < "$ROOT/$f" | cut -d' ' -f1)"
    else
      hash="$(shasum -a 256 < "$ROOT/$f" | cut -d' ' -f1)"
    fi
    [ -n "$files_json" ] && files_json="$files_json,"
    files_json="$files_json\"$f\":\"$hash\""
  fi
done

timestamp="$(date -Iseconds)"
state="{\"version\":1,\"timestamp\":\"$timestamp\",\"files\":{$files_json}}"
echo "$state" > "$INFRA/STRUCTURAL_STATE.json"
echo "[OK] Wrote $INFRA/STRUCTURAL_STATE.json"

KEY="${HOME}/.ssh/structural_key"
PUB="$INFRA/structural.pub"
if [ ! -f "$KEY" ]; then
  mkdir -p "$(dirname "$KEY")"
  ssh-keygen -t ed25519 -f "$KEY" -N "" -C "structural-signing@against-the-odds"
  cp "$KEY.pub" "$PUB"
  echo "[OK] Created key and saved public key to $PUB"
elif [ ! -f "$PUB" ]; then
  cp "$KEY.pub" "$PUB"
  echo "[OK] Saved public key to $PUB"
fi
# Keep allowed_signers in sync (principal from key comment)
principal="$(awk '{print $NF}' "$PUB")"
awk -v p="$principal" '{print p, $1, $2}' "$PUB" > "$INFRA/allowed_signers"

sig_out="$INFRA/STRUCTURAL_SIGNATURE.txt"
ssh-keygen -Y sign -f "$KEY" -n file < "$INFRA/STRUCTURAL_STATE.json" > "$sig_out" 2>/dev/null || \
  { sig_out="$INFRA/STRUCTURAL_SIGNATURE_NEW.txt"; ssh-keygen -Y sign -f "$KEY" -n file < "$INFRA/STRUCTURAL_STATE.json" > "$sig_out" || exit 1; }
echo "[OK] Signed and wrote $sig_out"
echo ""
echo "Next: Commit infra/STRUCTURAL_STATE.json, infra/STRUCTURAL_SIGNATURE.txt, infra/structural.pub"
