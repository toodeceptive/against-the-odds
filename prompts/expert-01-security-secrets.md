# Expert 1: Security & Secrets Management Guru

**Domain**: Security, authentication, authorization, secrets management, vulnerability assessment  
**Skills**: Security auditing, penetration testing, OWASP standards, encryption, token management  
**Objective**: Comprehensive security audit and hardening of all secrets, authentication, and security-sensitive components

## Focus Areas

### 1. Secrets Audit

- [ ] Scan all files for hardcoded credentials (API keys, tokens, passwords)
- [ ] Review `.env*` files and ensure `.env.local` is gitignored
- [ ] Audit GitHub Actions secrets usage and permissions
- [ ] Review Shopify/GitHub/Cloudflare credential storage
- [ ] Check for secrets in code comments, logs, or documentation
- [ ] Verify no secrets in version control history
- [ ] Assess secret rotation strategies and implement if missing

### 2. Authentication & Authorization

- [ ] Review all authentication implementations
- [ ] Assess token management (storage, refresh, expiry)
- [ ] Review authorization checks and role-based access
- [ ] Audit session management and security
- [ ] Review OAuth/API key handling
- [ ] Assess multi-factor authentication if applicable

### 3. Vulnerability Assessment

- [ ] Run security scanners (npm audit, Snyk, Trivy)
- [ ] Review dependency vulnerabilities
- [ ] Assess code-level security issues (SQL injection, XSS, CSRF)
- [ ] Review input validation and sanitization
- [ ] Assess error handling (no information leakage)
- [ ] Review file upload/download security

### 4. API Security

- [ ] Review API authentication mechanisms
- [ ] Assess rate limiting implementation
- [ ] Review request/response validation
- [ ] Check for API key exposure
- [ ] Review webhook security and validation
- [ ] Assess CORS configuration

### 5. Infrastructure Security

- [ ] Review GitHub Actions permissions (least privilege)
- [ ] Assess deployment security
- [ ] Review environment variable handling
- [ ] Check security headers (CSP, HSTS, etc.)
- [ ] Review SSL/TLS configuration
- [ ] Assess network security (firewall rules, etc.)

### 6. Security Best Practices

- [ ] Document security policies and procedures
- [ ] Create incident response plan
- [ ] Document security best practices
- [ ] Create security checklist for future development
- [ ] Review and update security documentation

## Deliverables

1. **Security Audit Report** (`docs/expert-analyses/expert_01_security_audit_YYYYMMDD.md`)
   - Findings categorized by severity
   - Vulnerabilities identified and prioritized
   - Recommendations with implementation steps
   - Security score/rating

2. **Secrets Inventory** (`docs/security/secrets_inventory.md`)
   - All secrets identified and categorized
   - Storage locations and access methods
   - Rotation schedules and procedures

3. **Security Hardening Recommendations**
   - Immediate fixes (critical vulnerabilities)
   - Short-term improvements (high priority)
   - Long-term enhancements (best practices)

4. **Updated Security Documentation**
   - Security policies
   - Incident response procedures
   - Security best practices guide

## Execution Checklist

- [ ] Run automated security scans
- [ ] Manual code review for security issues
- [ ] Review all configuration files
- [ ] Audit all integrations for security
- [ ] Review GitHub Actions workflows
- [ ] Test authentication/authorization flows
- [ ] Document all findings
- [ ] Create remediation plan
- [ ] Implement critical fixes
- [ ] Update documentation

## Success Criteria

- ✅ No hardcoded secrets found
- ✅ All secrets properly managed
- ✅ No critical vulnerabilities
- ✅ Security best practices implemented
- ✅ Documentation complete
- ✅ Security monitoring in place
