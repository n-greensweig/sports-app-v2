# Hosting Setup for Legal Pages

This guide explains how to host the legal pages (Privacy Policy, Terms of Service, Support) for the SportsIQ app.

## Overview

Apple requires publicly accessible URLs for:
- **Privacy Policy** (required)
- **Support URL** (required)
- **Terms of Service** (recommended)
- **Marketing URL** (optional)

These pages must be:
- Publicly accessible (no authentication required)
- Mobile-friendly and responsive
- Available via HTTPS
- Stable and reliable (no downtime)

## Recommended Solution: GitHub Pages

**Why GitHub Pages?**
- ✅ Free hosting
- ✅ HTTPS by default
- ✅ Easy to update (just push to repo)
- ✅ Reliable uptime
- ✅ Custom domain support
- ✅ Version control for legal documents
- ✅ No server maintenance required

### Setup Instructions

#### Step 1: Create a Dedicated Repository (Option A)

**Create a new repository for legal pages**:

```bash
# Create new repository on GitHub
# Name: sportsiq-legal or sportsiq-website

# Clone locally
git clone https://github.com/[YOUR_USERNAME]/sportsiq-legal.git
cd sportsiq-legal

# Create directory structure
mkdir -p docs
```

#### Step 1 (Alternative): Use Existing Repository (Option B)

**Use the existing SportsIQ repository**:

```bash
cd /Users/noahgreensweig/Desktop/SportsIQ

# Create docs directory if it doesn't exist
mkdir -p docs/legal

# Copy legal documents
# (already done in our case)
```

#### Step 2: Convert Markdown to HTML

**Option A: Use a Static Site Generator**

**Using Jekyll** (GitHub Pages default):

1. Create `_config.yml`:
```yaml
title: SportsIQ Legal
description: Legal documents for SportsIQ app
theme: jekyll-theme-minimal
markdown: kramdown
```

2. Create `index.html`:
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SportsIQ - Legal</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
        }
        h1 { color: #2D5016; }
        a { color: #2D5016; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .nav { margin: 40px 0; }
        .nav a { margin-right: 20px; }
    </style>
</head>
<body>
    <h1>SportsIQ Legal Documents</h1>
    <div class="nav">
        <a href="privacy-policy.html">Privacy Policy</a>
        <a href="terms-of-service.html">Terms of Service</a>
        <a href="support.html">Support</a>
    </div>
    <p>Welcome to SportsIQ. Please review our legal documents above.</p>
</body>
</html>
```

3. Convert Markdown files to HTML or use Jekyll to render them automatically

**Option B: Simple HTML Files**

Create standalone HTML files for each legal document:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Privacy Policy - SportsIQ</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
        }
        h1, h2, h3 { color: #2D5016; }
        a { color: #2D5016; }
        code { background: #f4f4f4; padding: 2px 6px; border-radius: 3px; }
    </style>
</head>
<body>
    <!-- Paste converted HTML content here -->
</body>
</html>
```

**Option C: Use a Markdown-to-HTML Converter**

Tools to convert Markdown to HTML:
- **Pandoc**: `pandoc privacy-policy.md -o privacy-policy.html`
- **Marked**: Online converter at [marked.js.org](https://marked.js.org)
- **VS Code Extension**: Markdown Preview Enhanced

#### Step 3: Enable GitHub Pages

1. Go to repository settings on GitHub
2. Navigate to "Pages" section
3. Under "Source", select:
   - Branch: `main` (or `master`)
   - Folder: `/docs` (if using docs folder) or `/` (root)
4. Click "Save"
5. GitHub will provide a URL: `https://[username].github.io/[repo-name]/`

#### Step 4: Verify Deployment

1. Wait 1-2 minutes for deployment
2. Visit the provided URL
3. Test all links:
   - `https://[username].github.io/[repo-name]/privacy-policy.html`
   - `https://[username].github.io/[repo-name]/terms-of-service.html`
   - `https://[username].github.io/[repo-name]/support.html`
4. Verify mobile responsiveness
5. Check HTTPS is working

#### Step 5: Update App Configuration

Update the URLs in your app and App Store Connect:

**In Xcode Info.plist**:
```xml
<key>NSPrivacyPolicyURL</key>
<string>https://[username].github.io/[repo-name]/privacy-policy.html</string>

<key>NSSupportURL</key>
<string>https://[username].github.io/[repo-name]/support.html</string>
```

**In App Store Connect**:
- Privacy Policy URL: `https://[username].github.io/[repo-name]/privacy-policy.html`
- Support URL: `https://[username].github.io/[repo-name]/support.html`
- Marketing URL (optional): `https://[username].github.io/[repo-name]/`

## Alternative Hosting Solutions

### Option 2: Custom Domain with GitHub Pages

**Benefits**: Professional appearance, brand consistency

**Setup**:
1. Purchase domain (e.g., `sportsiq.app` or `legal.sportsiq.app`)
2. In GitHub repo settings → Pages → Custom domain
3. Enter your domain: `legal.sportsiq.app`
4. Configure DNS records with your domain provider:
   ```
   Type: CNAME
   Name: legal
   Value: [username].github.io
   ```
5. Wait for DNS propagation (up to 24 hours)
6. Enable "Enforce HTTPS" in GitHub Pages settings

**URLs become**:
- `https://legal.sportsiq.app/privacy-policy.html`
- `https://legal.sportsiq.app/terms-of-service.html`
- `https://legal.sportsiq.app/support.html`

### Option 3: Netlify

**Benefits**: Easy deployment, automatic HTTPS, custom domains

**Setup**:
1. Sign up at [netlify.com](https://netlify.com)
2. Connect GitHub repository
3. Configure build settings (if using Jekyll/Hugo)
4. Deploy
5. Netlify provides URL: `https://[site-name].netlify.app`
6. Optional: Add custom domain

### Option 4: Vercel

**Benefits**: Fast deployment, excellent performance, free tier

**Setup**:
1. Sign up at [vercel.com](https://vercel.com)
2. Import GitHub repository
3. Configure project settings
4. Deploy
5. Vercel provides URL: `https://[project-name].vercel.app`

### Option 5: AWS S3 + CloudFront

**Benefits**: Scalable, professional, full control

**Drawbacks**: More complex setup, potential costs

**Setup** (brief):
1. Create S3 bucket
2. Upload HTML files
3. Enable static website hosting
4. Configure CloudFront for HTTPS
5. Point custom domain to CloudFront

### Option 6: Firebase Hosting

**Benefits**: Google infrastructure, free tier, easy deployment

**Setup**:
1. Install Firebase CLI: `npm install -g firebase-tools`
2. Initialize Firebase: `firebase init hosting`
3. Deploy: `firebase deploy`
4. URL: `https://[project-id].web.app`

## Recommended Approach for SportsIQ

**For MVP/V1**: Use **GitHub Pages** with the existing repository

**Advantages**:
- Zero cost
- Simple setup
- Documents already in repo
- Easy to update (just push changes)
- Reliable hosting

**Implementation**:
1. Convert Markdown files to HTML (or use Jekyll)
2. Place in `/docs` folder
3. Enable GitHub Pages
4. Update app configuration with URLs

**For Production/Future**: Consider **custom domain** with GitHub Pages or Netlify

**Advantages**:
- Professional appearance (`legal.sportsiq.app`)
- Brand consistency
- Still free or low-cost
- Easy migration from GitHub Pages

## File Structure

### Recommended Structure for GitHub Pages

```
sportsiq/
├── docs/
│   ├── legal/
│   │   ├── index.html (landing page)
│   │   ├── privacy-policy.html
│   │   ├── terms-of-service.html
│   │   └── support.html
│   ├── marketing/
│   │   └── (future marketing pages)
│   └── assets/
│       ├── css/
│       │   └── style.css
│       └── images/
│           └── logo.png
├── _config.yml (if using Jekyll)
└── README.md
```

### URL Structure

```
https://[username].github.io/sportsiq/legal/
├── privacy-policy.html
├── terms-of-service.html
└── support.html
```

## Styling Recommendations

### Responsive CSS Template

```css
/* style.css */
:root {
    --primary-color: #2D5016;
    --text-color: #333;
    --background: #fff;
    --max-width: 800px;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
    line-height: 1.6;
    color: var(--text-color);
    background: var(--background);
    padding: 20px;
}

.container {
    max-width: var(--max-width);
    margin: 0 auto;
}

h1, h2, h3, h4 {
    color: var(--primary-color);
    margin-top: 1.5em;
    margin-bottom: 0.5em;
}

h1 { font-size: 2em; }
h2 { font-size: 1.5em; }
h3 { font-size: 1.25em; }

p {
    margin-bottom: 1em;
}

a {
    color: var(--primary-color);
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

ul, ol {
    margin-left: 2em;
    margin-bottom: 1em;
}

code {
    background: #f4f4f4;
    padding: 2px 6px;
    border-radius: 3px;
    font-family: 'Monaco', 'Courier New', monospace;
}

.header {
    border-bottom: 2px solid var(--primary-color);
    padding-bottom: 20px;
    margin-bottom: 30px;
}

.footer {
    border-top: 1px solid #ddd;
    margin-top: 40px;
    padding-top: 20px;
    text-align: center;
    color: #666;
    font-size: 0.9em;
}

/* Mobile responsiveness */
@media (max-width: 600px) {
    body {
        padding: 10px;
    }
    
    h1 { font-size: 1.5em; }
    h2 { font-size: 1.25em; }
    h3 { font-size: 1.1em; }
}
```

## Maintenance and Updates

### Updating Legal Documents

1. Edit Markdown files locally
2. Convert to HTML (if not using Jekyll)
3. Commit and push to GitHub
4. Changes automatically deploy to GitHub Pages
5. Verify updates are live

### Version Control

- Keep Markdown source files in version control
- Tag major updates: `git tag v1.0-legal-update`
- Maintain changelog for legal document updates

### Notifications

When updating legal documents:
- Update "Last Updated" date
- Notify users via in-app message (for material changes)
- Send email to users (for significant changes)
- Update version in App Store Connect

## Testing Checklist

Before going live:
- [ ] All pages load correctly
- [ ] HTTPS is enabled
- [ ] Links between pages work
- [ ] Mobile-responsive design
- [ ] No broken links
- [ ] Contact information is correct
- [ ] Placeholder text replaced with actual info
- [ ] Pages load quickly (< 2 seconds)
- [ ] Tested on multiple devices (iPhone, iPad, desktop)
- [ ] Tested on multiple browsers (Safari, Chrome, Firefox)
- [ ] URLs added to App Store Connect
- [ ] URLs added to app Info.plist

## Placeholder Replacement Checklist

Before deploying, replace these placeholders in legal documents:

- [ ] `[SUPPORT_EMAIL]` → Actual support email
- [ ] `[COMPANY_ADDRESS]` → Physical address (if required)
- [ ] `[LEGAL_ENTITY_NAME]` → Legal company name
- [ ] `[SUPPORT_URL]` → Actual support page URL
- [ ] `[PRIVACY_POLICY_URL]` → Actual privacy policy URL
- [ ] `[JURISDICTION]` → Legal jurisdiction (e.g., "California, USA")
- [ ] `[SPECIFY REGION]` → Supabase data region
- [ ] `[BUSINESS_EMAIL]` → Business inquiries email
- [ ] `[DEMO_PASSWORD]` → Demo account password (if needed)

## Next Steps

1. **Choose hosting solution**: GitHub Pages (recommended for MVP)
2. **Convert Markdown to HTML**: Use Jekyll or manual conversion
3. **Set up repository**: Enable GitHub Pages
4. **Replace placeholders**: Add actual company information
5. **Deploy and test**: Verify all pages are accessible
6. **Update app configuration**: Add URLs to Info.plist and App Store Connect
7. **Monitor**: Ensure pages remain accessible

---

**Recommended Timeline**:
- Day 1: Convert Markdown to HTML, set up GitHub Pages
- Day 2: Replace placeholders, test deployment
- Day 3: Update app configuration, final verification
