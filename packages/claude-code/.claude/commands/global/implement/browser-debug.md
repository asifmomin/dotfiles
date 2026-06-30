---
description: Debug web pages using Playwright browser automation
argument-hint: [url-or-description]
---

# Browser Debug Workflow

## Input Handling

<input_handling>
**If $ARGUMENTS is a URL:**
- Navigate to the URL first using browser_navigate
- Then proceed with the debug workflow

**If $ARGUMENTS is a description:**
- Assume the browser is already on the relevant page
- Proceed with the debug workflow

**If $ARGUMENTS is empty:**
- Use AskUserQuestion to ask what page or issue to debug
- Wait for response before proceeding
</input_handling>

## Debug Workflow

Execute these steps in order:

### 1. Capture Current State
- Take a browser snapshot using `browser_snapshot` to capture the accessibility tree
- This shows the current page structure and any visible issues

### 2. Check Console for Errors
- Use `browser_console_messages` with level "error" to get all errors
- Also check "warning" level for potential issues
- Report any JavaScript errors, failed network requests, or warnings

### 3. Check Network Requests
- Use `browser_network_requests` to see failed API calls
- Look for 4xx/5xx status codes
- Identify slow or hanging requests

### 4. Identify Root Cause
- Analyze the snapshot, console errors, and network failures together
- Correlate errors with visible UI issues
- Identify the most likely root cause

### 5. Report Findings
Present findings in this format:

```
## Debug Summary

**Page:** [URL or description]

### Console Errors
- [List any errors found, or "None"]

### Network Issues
- [List failed/slow requests, or "None"]

### Visual Issues
- [Issues visible in snapshot]

### Root Cause
[Most likely cause of the issue]

### Suggested Fix
[Specific code changes or actions to resolve]
```

## Important Notes

- Always snapshot FIRST before any other diagnostic steps
- If authentication errors occur, report immediately and wait for user action
- Focus on actionable findings, not every minor warning
