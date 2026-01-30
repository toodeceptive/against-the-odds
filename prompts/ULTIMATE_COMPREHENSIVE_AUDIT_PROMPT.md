# Ultimate Comprehensive Audit & Optimization Prompt

**Purpose**: Master prompt for systematic audit, review, testing, and optimization of every aspect of the repository, environment, integrations, and tooling.

**Usage**: Apply this prompt to any component, file, directory, integration, or system aspect. Use it iteratively to achieve perfection across all dimensions.

---

## Core Audit Framework

### Phase 1: Discovery & Inventory

1. **Map the component/system**:
   - What is it? (file, directory, integration, workflow, tool, etc.)
   - What is its purpose and scope?
   - What are its dependencies and dependents?
   - What are its inputs, outputs, and side effects?
   - What standards/best practices apply to it?

2. **Gather context**:
   - Read all related documentation
   - Review configuration files
   - Check for related issues/PRs/comments
   - Examine similar implementations in the codebase
   - Research industry best practices and standards

### Phase 2: Analysis & Evaluation

3. **Code Quality Audit**:
   - [ ] **Syntax & Structure**: Valid syntax, proper formatting, consistent style
   - [ ] **Architecture**: Follows SOLID principles, proper separation of concerns
   - [ ] **Performance**: No bottlenecks, efficient algorithms, proper caching
   - [ ] **Security**: No hardcoded secrets, proper input validation, secure APIs
   - [ ] **Error Handling**: Comprehensive try/catch, meaningful error messages
   - [ ] **Logging**: Appropriate log levels, structured logging, no sensitive data
   - [ ] **Documentation**: Inline comments, JSDoc/TSDoc, README updates
   - [ ] **Testing**: Unit tests, integration tests, edge cases covered
   - [ ] **Accessibility**: WCAG compliance (if UI), keyboard navigation
   - [ ] **Internationalization**: i18n support if needed, proper encoding

4. **Configuration Audit**:
   - [ ] **Correctness**: Valid syntax, proper values, no typos
   - [ ] **Completeness**: All required fields present, optional fields documented
   - [ ] **Security**: No secrets in config, proper permissions, least privilege
   - [ ] **Environment-specific**: Proper .env handling, no hardcoded paths
   - [ ] **Versioning**: Pinned versions where needed, compatible versions
   - [ ] **Documentation**: Config options explained, examples provided

5. **Integration Audit**:
   - [ ] **Authentication**: Proper credentials handling, token refresh, expiry handling
   - [ ] **API Usage**: Correct endpoints, proper request/response handling
   - [ ] **Rate Limiting**: Respects limits, implements backoff, handles 429s
   - [ ] **Error Handling**: Handles API errors gracefully, retries appropriately
   - [ ] **Data Validation**: Validates inputs/outputs, handles malformed data
   - [ ] **Monitoring**: Logs API calls, tracks failures, alerts on issues
   - [ ] **Documentation**: API docs referenced, integration steps documented

6. **Workflow & Process Audit**:
   - [ ] **CI/CD**: Tests run, builds succeed, deployments are safe
   - [ ] **Git Workflow**: Proper branching, meaningful commits, PR templates
   - [ ] **Dependencies**: Up-to-date, no vulnerabilities, proper versioning
   - [ ] **Documentation**: README accurate, setup instructions work
   - [ ] **Monitoring**: Health checks, error tracking, performance metrics

7. **Tooling & Environment Audit**:
   - [ ] **IDE/Editor**: Extensions installed, settings configured, shortcuts set
   - [ ] **Linters/Formatters**: Rules configured, auto-fix enabled, CI integration
   - [ ] **Build Tools**: Optimized configs, proper caching, fast builds
   - [ ] **Package Managers**: Lock files committed, versions pinned
   - [ ] **Development Environment**: Easy setup, reproducible, documented

### Phase 3: Optimization & Enhancement

8. **Performance Optimization**:
   - [ ] Identify bottlenecks (profiling, timing, memory usage)
   - [ ] Optimize algorithms (time/space complexity)
   - [ ] Implement caching where appropriate
   - [ ] Reduce bundle sizes (tree-shaking, code splitting)
   - [ ] Optimize images/assets (compression, lazy loading)
   - [ ] Database query optimization (indexes, N+1 prevention)

9. **Security Hardening**:
   - [ ] Remove all hardcoded secrets
   - [ ] Implement proper secret management
   - [ ] Add input validation and sanitization
   - [ ] Review and fix security vulnerabilities
   - [ ] Implement proper authentication/authorization
   - [ ] Add security headers (CSP, HSTS, etc.)
   - [ ] Regular dependency audits

10. **Code Quality Improvements**:
    - [ ] Refactor for clarity and maintainability
    - [ ] Remove dead code and unused dependencies
    - [ ] Improve naming conventions
    - [ ] Add missing error handling
    - [ ] Improve type safety (TypeScript, JSDoc)
    - [ ] Add comprehensive tests
    - [ ] Improve documentation

11. **Developer Experience**:
    - [ ] Improve setup process (scripts, docs, automation)
    - [ ] Add helpful error messages
    - [ ] Improve debugging tools and logs
    - [ ] Add development scripts and shortcuts
    - [ ] Improve IDE integration and autocomplete

### Phase 4: Testing & Validation

12. **Test Coverage**:
    - [ ] Unit tests for all functions/methods
    - [ ] Integration tests for workflows
    - [ ] E2E tests for critical paths
    - [ ] Edge case testing
    - [ ] Error scenario testing
    - [ ] Performance testing
    - [ ] Security testing

13. **Validation**:
    - [ ] All tests pass
    - [ ] Linting passes
    - [ ] Formatting is consistent
    - [ ] Build succeeds
    - [ ] No security vulnerabilities
    - [ ] Documentation is accurate
    - [ ] Integration tests work

### Phase 5: Documentation & Finalization

14. **Documentation**:
    - [ ] README updated with current state
    - [ ] Code comments explain complex logic
    - [ ] API documentation is complete
    - [ ] Setup instructions are accurate
    - [ ] Troubleshooting guide updated
    - [ ] Architecture decisions documented
    - [ ] Changelog updated

15. **Final Checks**:
    - [ ] All todos completed
    - [ ] All issues resolved
    - [ ] Code reviewed
    - [ ] Tests passing
    - [ ] Documentation complete
    - [ ] Ready for production

---

## Specific Component Checklists

### For Code Files (.js, .ts, .jsx, .tsx)

- [ ] Follows project coding standards
- [ ] Proper imports/exports
- [ ] No console.logs in production code
- [ ] Proper error handling
- [ ] Type safety (TypeScript or JSDoc)
- [ ] Unit tests exist and pass
- [ ] No hardcoded values
- [ ] Proper async/await usage
- [ ] Memory leaks checked
- [ ] Performance optimized

### For Configuration Files (.json, .yml, .yaml, .toml)

- [ ] Valid syntax
- [ ] All required fields present
- [ ] No secrets committed
- [ ] Proper comments/documentation
- [ ] Environment-specific values handled
- [ ] Version pins where needed
- [ ] Follows schema/standard

### For Workflow Files (.github/workflows/\*.yml)

- [ ] Proper triggers configured
- [ ] Permissions set correctly (least privilege)
- [ ] Actions pinned to versions
- [ ] Secrets properly referenced
- [ ] Timeouts set appropriately
- [ ] Caching implemented
- [ ] Error handling (no `|| true` masking failures)
- [ ] Proper job dependencies
- [ ] Artifacts handled correctly

### For Documentation Files (.md)

- [ ] Accurate and up-to-date
- [ ] Proper markdown formatting
- [ ] Links work correctly
- [ ] Code examples are tested
- [ ] Table of contents for long docs
- [ ] Screenshots/diagrams if needed
- [ ] Version/date information

### For Package Files (package.json, requirements.txt, etc.)

- [ ] All dependencies listed
- [ ] Versions pinned appropriately
- [ ] No security vulnerabilities
- [ ] Dev dependencies separated
- [ ] Scripts are documented
- [ ] Repository info correct
- [ ] License specified

### For Environment Files (.env.example, .env.local)

- [ ] All required variables listed
- [ ] Sensitive values use placeholders
- [ ] Comments explain each variable
- [ ] Default values where appropriate
- [ ] .env.local in .gitignore
- [ ] Example values are realistic

### For Integration Configs (Shopify, GitHub, Cloudflare, etc.)

- [ ] Credentials stored securely
- [ ] API versions specified correctly
- [ ] Rate limits respected
- [ ] Error handling implemented
- [ ] Webhooks configured properly
- [ ] Permissions are minimal required
- [ ] Connection tested and verified

### For Database/Data Files

- [ ] Schema is documented
- [ ] Migrations are versioned
- [ ] Indexes are optimized
- [ ] Backups configured
- [ ] Data validation rules
- [ ] Privacy/GDPR compliance

### For Build/Deploy Configs

- [ ] Build outputs optimized
- [ ] Source maps for production
- [ ] Environment variables handled
- [ ] Deployment steps documented
- [ ] Rollback procedures defined
- [ ] Health checks configured

---

## Best Practices Reference

### Coding Standards

- **JavaScript/TypeScript**: ESLint + Prettier, strict mode, no `any` types
- **Naming**: camelCase for variables/functions, PascalCase for classes, UPPER_CASE for constants
- **Functions**: Single responsibility, max 50 lines, clear parameters
- **Comments**: Explain "why", not "what", JSDoc for public APIs
- **Error Handling**: Always catch, meaningful messages, proper logging

### Security

- **Secrets**: Never commit, use env vars, rotate regularly
- **Input Validation**: Validate all inputs, sanitize user data
- **Dependencies**: Regular audits, pin versions, review changes
- **Authentication**: Strong tokens, proper expiry, refresh mechanisms
- **Authorization**: Least privilege, role-based access

### Performance

- **Database**: Indexes, query optimization, connection pooling
- **API**: Caching, rate limiting, pagination
- **Frontend**: Code splitting, lazy loading, image optimization
- **Build**: Tree-shaking, minification, compression

### Testing

- **Coverage**: Aim for 80%+, critical paths 100%
- **Types**: Unit, integration, E2E, performance, security
- **Naming**: Descriptive test names, arrange-act-assert pattern
- **Isolation**: Tests independent, no shared state, proper cleanup

### Documentation

- **README**: Setup, usage, architecture overview
- **Code**: Inline comments for complex logic, JSDoc for APIs
- **API**: Endpoints, request/response formats, examples
- **Decisions**: ADRs for significant choices

---

## Execution Strategy

### 1. Systematic Approach

- Start with highest-risk/highest-impact components
- Work directory by directory, file by file
- Use checklists to ensure completeness
- Document findings and fixes

### 2. Tool-Assisted Review

- **Linters**: ESLint, Prettier, Stylelint
- **Security**: npm audit, Snyk, Trivy
- **Testing**: Vitest, Playwright, Jest
- **Performance**: Lighthouse, WebPageTest, profilers
- **Dependencies**: depcheck, npm-check-updates

### 3. Iterative Improvement

- Fix critical issues first
- Optimize incrementally
- Test after each change
- Document improvements
- Re-audit after major changes

### 4. Quality Gates

- All tests must pass
- Linting must pass
- Security scans clean
- Documentation updated
- Code reviewed

---

## Component-Specific Prompts

### For a Code File

```
Audit this file comprehensively:
1. Review code quality (structure, performance, security, error handling)
2. Check adherence to project standards and best practices
3. Verify proper testing coverage
4. Review documentation and comments
5. Check for security vulnerabilities
6. Optimize performance if needed
7. Ensure proper error handling
8. Update documentation
9. Run tests and verify they pass
10. Finalize and ensure production-ready
```

### For a Configuration File

```
Audit this configuration:
1. Verify syntax is valid
2. Check all required fields are present
3. Ensure no secrets are committed
4. Verify environment-specific values are handled
5. Check version pins are appropriate
6. Review permissions and security settings
7. Validate against schema/standard
8. Update documentation
9. Test configuration works correctly
10. Finalize and ensure optimal
```

### For an Integration

```
Audit this integration comprehensively:
1. Review authentication/authorization setup
2. Verify API usage is correct and efficient
3. Check error handling and retry logic
4. Review rate limiting and quota management
5. Verify data validation and sanitization
6. Check monitoring and logging
7. Review security (secrets, permissions)
8. Test connection and functionality
9. Update documentation
10. Finalize and ensure production-ready
```

### For a Workflow/Process

```
Audit this workflow comprehensively:
1. Review workflow logic and dependencies
2. Check error handling and failure modes
3. Verify security (permissions, secrets)
4. Review performance and optimization
5. Check monitoring and alerting
6. Review documentation
7. Test workflow end-to-end
8. Verify rollback/recovery procedures
9. Update runbooks/documentation
10. Finalize and ensure optimal
```

---

## Master Execution Command

When applying this prompt to any component, follow this structure:

1. **Identify**: What component/system are you auditing?
2. **Discover**: Gather all relevant information (read files, check docs, review related code)
3. **Analyze**: Apply relevant checklists from Phase 2
4. **Optimize**: Apply Phase 3 improvements
5. **Test**: Run Phase 4 validation
6. **Document**: Complete Phase 5 documentation
7. **Verify**: Final checks and sign-off

---

## Success Criteria

A component is "perfect" when:

- ✅ All code quality checks pass
- ✅ All security checks pass
- ✅ All tests pass with good coverage
- ✅ Performance is optimal
- ✅ Documentation is complete and accurate
- ✅ Follows all best practices
- ✅ Ready for production use
- ✅ Maintainable and extensible
- ✅ No technical debt
- ✅ No known issues

---

## Continuous Improvement

- Re-audit after major changes
- Regular dependency updates
- Periodic security scans
- Performance monitoring
- Code review process
- Documentation updates
- Best practice evolution

---

**Remember**: Perfection is iterative. Use this prompt systematically, component by component, to achieve comprehensive excellence across the entire codebase, environment, and tooling.
