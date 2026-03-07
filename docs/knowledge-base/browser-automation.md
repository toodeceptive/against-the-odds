# Browser Automation Patterns

## Connection Patterns

### Connect to Existing Browser

```javascript
const browser = await connectToBrowser({ useExisting: true });
```

### Launch New Browser

```javascript
const browser = await connectToBrowser({ useExisting: false, headless: false });
```

## Navigation Patterns

### Wait for Page Load

```javascript
await page.goto(url, { waitUntil: 'networkidle' });
```

### Wait for Element

```javascript
await page.waitForSelector('[data-loaded]', { timeout: 10000 });
```

## Interaction Patterns

### Safe Click

```javascript
await safeClick(page.locator('button.submit'));
```

### Safe Fill

```javascript
await safeFill(page.locator('input[name="email"]'), 'user@example.com');
```

## Data Extraction Patterns

### Extract Text

```javascript
const text = await extractText(page, 'h1.title');
```

### Extract Table Data

```javascript
const data = await extractTableData(page, 'table.products');
```

## Error Handling Patterns

### Retry with Backoff

```javascript
const result = await retryWithBackoff(
  async () => {
    return await page.click('button');
  },
  3,
  1000
);
```

### Screenshot on Error

```javascript
try {
  await page.click('button');
} catch (error) {
  await takeScreenshot(page, 'error.png');
  throw error;
}
```

## Best Practices

1. **Always wait**: Wait for elements before interacting
2. **Use retries**: Implement retry logic for flaky operations
3. **Take screenshots**: Capture screenshots on errors
4. **Reuse browser**: Connect to existing browser when possible
5. **Handle login**: Check and handle login states
6. **Clean up**: Close browser instances after use

## Common Patterns

### Login Flow

```javascript
const loggedIn = await ensureShopifyLogin(page, storeDomain);
if (!loggedIn) {
  // Handle login failure
}
```

### Data Extraction Flow

```javascript
await navigateToAppsDevelopment(page);
const token = await extractAccessToken(page);
```

### Form Submission Flow

```javascript
await safeFill(page.locator('input[name="field"]'), 'value');
await safeClick(page.locator('button[type="submit"]'));
await waitForNetworkIdle(page);
```

## References

- [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- [Browser Automation Library](../src/browser-automation/)
