# Coding Standards & Best Practices

**Version:** 1.0  
**Last Updated:** January 28, 2026  
**Status:** Active

---

## Overview

This document defines coding standards, best practices, and quality guidelines for the "Against The Odds" project.

---

## HTML Standards

### Structure
- Use semantic HTML5 elements
- Proper document structure with `<header>`, `<main>`, `<footer>`, `<nav>`, `<article>`, `<section>`
- Logical heading hierarchy (h1 → h2 → h3, etc.)

### Accessibility
- All images must have descriptive `alt` attributes
- Form inputs must have associated `<label>` elements
- Use ARIA labels where appropriate
- Ensure keyboard navigation works
- Maintain WCAG AA compliance

### SEO
- Proper meta tags (`description`, `keywords`, `og:*`, `twitter:*`)
- Semantic markup for search engines
- Proper heading structure
- Descriptive page titles

### Performance
- Minimize DOM depth
- Use efficient selectors
- Lazy load images below the fold
- Optimize asset loading

---

## CSS Standards

### Naming Convention
- Use **BEM (Block Element Modifier)** methodology
- Format: `.block__element--modifier`
- Example: `.hero__title--large`

### Organization
- Mobile-first responsive design
- Use CSS variables for theming
- Modular component-based structure
- Separate files: `base.css`, `components.css`, `layout.css`, `utilities.css`

### Best Practices
- Use CSS Grid and Flexbox for layouts
- Avoid `!important` unless necessary
- Use relative units (rem, em, %) over fixed pixels
- Optimize for performance (minimize repaints/reflows)

### Browser Compatibility
- Support modern browsers (last 2 versions)
- Use autoprefixer for vendor prefixes
- Test in Chrome, Firefox, Safari, Edge

---

## JavaScript Standards

### Syntax
- Use ES6+ features
- Prefer `const` over `let`, avoid `var`
- Use arrow functions where appropriate
- Template literals for strings
- Destructuring for objects/arrays

### Structure
- Modular architecture
- Use ES6 modules (`import`/`export`)
- Separate concerns (logic, UI, data)
- Single Responsibility Principle

### Error Handling
- Always use try-catch for async operations
- Provide meaningful error messages
- Log errors appropriately
- Handle edge cases

### Performance
- Avoid unnecessary DOM manipulation
- Use event delegation
- Debounce/throttle expensive operations
- Lazy load when possible

### Code Quality
- Functions should be small and focused
- Use descriptive variable/function names
- Add JSDoc comments for complex functions
- Keep functions pure when possible

---

## File Organization

### Directory Structure
```
src/
├── html/
│   ├── index.html
│   ├── about.html
│   └── ...
├── css/
│   ├── base/
│   ├── components/
│   ├── layout/
│   └── utilities/
├── js/
│   ├── modules/
│   ├── utils/
│   └── main.js
└── assets/
    ├── images/
    ├── fonts/
    └── icons/
```

### Naming Conventions
- Files: `kebab-case` (e.g., `user-profile.js`)
- Classes: `PascalCase` (e.g., `UserProfile`)
- Functions/Variables: `camelCase` (e.g., `getUserData`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `API_BASE_URL`)

---

## Code Review Checklist

### Before Submitting
- [ ] Code follows style guide
- [ ] No console.log statements in production code
- [ ] All functions have error handling
- [ ] Code is commented where necessary
- [ ] No hardcoded values (use constants/config)
- [ ] Performance considerations addressed
- [ ] Accessibility requirements met
- [ ] Browser compatibility verified
- [ ] No security vulnerabilities
- [ ] Tests pass (when applicable)

### Review Criteria
- **Functionality:** Does it work as intended?
- **Quality:** Is the code clean and maintainable?
- **Performance:** Are there any performance issues?
- **Security:** Any security concerns?
- **Accessibility:** WCAG AA compliant?
- **Documentation:** Is it well-documented?

---

## Git Commit Standards

### Commit Message Format
```
type(scope): description

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding/updating tests
- `chore`: Maintenance tasks

### Examples
```
feat(landing): add hero section with CTA button
fix(cart): resolve checkout button disabled state
docs(readme): update installation instructions
refactor(api): optimize data fetching logic
```

---

## Performance Standards

### Targets
- Page load time: < 2 seconds
- Time to interactive: < 3 seconds
- First contentful paint: < 1 second
- Lighthouse score: > 90
- Core Web Vitals: All "Good"

### Optimization Checklist
- [ ] Images optimized and compressed
- [ ] CSS/JS minified for production
- [ ] Assets served from CDN
- [ ] Caching strategy implemented
- [ ] Lazy loading for images
- [ ] Code splitting implemented
- [ ] Gzip/Brotli compression enabled

---

## Security Standards

### Checklist
- [ ] No secrets in code (use environment variables)
- [ ] Input validation on all user inputs
- [ ] XSS protection (sanitize user content)
- [ ] CSRF protection for forms
- [ ] HTTPS enforced
- [ ] Content Security Policy (CSP) headers
- [ ] Regular dependency updates
- [ ] Security headers configured

---

## Testing Standards

### Test Coverage
- Unit tests for utility functions
- Integration tests for components
- E2E tests for critical user flows
- Target: 90%+ code coverage

### Testing Tools
- Jest for unit testing
- Playwright for E2E testing
- Lighthouse for performance
- axe for accessibility

---

## Documentation Standards

### Code Documentation
- JSDoc comments for functions
- Inline comments for complex logic
- README for each major component
- API documentation for endpoints

### Project Documentation
- README.md with setup instructions
- ARCHITECTURE.md for system design
- DEPLOYMENT.md for deployment process
- CHANGELOG.md for version history

---

## Resources

- [MDN Web Docs](https://developer.mozilla.org/)
- [Web.dev Best Practices](https://web.dev/)
- [WCAG Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [BEM Methodology](http://getbem.com/)

---

**Last Reviewed:** January 28, 2026  
**Next Review:** February 28, 2026
