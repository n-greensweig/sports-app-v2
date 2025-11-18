# Supabase Authentication Setup Guide

**Task 8: Authentication Integration**
**Last Updated**: 2025-11-17
**Auth Provider**: Supabase Auth (with Email, Apple, Google)

---

## Overview

This guide walks you through setting up Supabase Authentication for SportsIQ, including:
- Email/Password authentication
- Apple Sign In (recommended for iOS)
- Google OAuth
- Session management and token refresh

---

## Part 1: Enable Authentication in Supabase Dashboard

### Step 1: Access Authentication Settings

1. Go to https://supabase.com and log in
2. Select your **sportsiq** project
3. Click **Authentication** in the left sidebar
4. Click **Providers** tab

### Step 2: Configure Email Authentication

1. **Email** provider should be enabled by default
2. If not, toggle **Email** to ON
3. Configure email settings:
   - **Confirm email**: Toggle ON (recommended for production)
   - **Secure email change**: Toggle ON
   - **Secure password change**: Toggle ON

4. **Email Templates** (optional but recommended):
   - Click **Email Templates** tab
   - Customize confirmation, password reset, magic link emails
   - Add your app branding

### Step 3: Enable Apple Sign In

1. In **Providers** tab, find **Apple**
2. Toggle **Apple Enabled** to ON
3. You'll need to configure Apple Developer credentials:
   - **Services ID** (Client ID)
   - **Team ID**
   - **Key ID**
   - **Private Key** (.p8 file)

**Apple Developer Setup** (detailed steps):

#### 3.1 Create App ID
1. Go to https://developer.apple.com/account
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** button
4. Select **App IDs** → **Continue**
5. Enter:
   - Description: `SportsIQ`
   - Bundle ID: `com.sportsiq.app` (or your bundle ID)
6. Check **Sign In with Apple** capability
7. Click **Continue** → **Register**

#### 3.2 Create Services ID
1. In **Identifiers**, click **+** button again
2. Select **Services IDs** → **Continue**
3. Enter:
   - Description: `SportsIQ Auth`
   - Identifier: `com.sportsiq.auth` (note this - it's your **Services ID**)
4. Click **Continue** → **Register**
5. Find your new Services ID in the list, click it
6. Check **Sign In with Apple**
7. Click **Configure**
8. Primary App ID: Select your SportsIQ App ID
9. **Domains and Subdomains**: Add `gzghfnqpzjmcsenrnjme.supabase.co`
10. **Return URLs**: Add `https://gzghfnqpzjmcsenrnjme.supabase.co/auth/v1/callback`
11. Click **Save** → **Continue** → **Save**

#### 3.3 Create Key
1. Navigate to **Keys** → **+** button
2. Enter Key Name: `SportsIQ Sign In with Apple Key`
3. Check **Sign In with Apple**
4. Click **Configure** → Select your App ID → **Save**
5. Click **Continue** → **Register**
6. **Download the .p8 key file** (you can only download once!)
7. Note the **Key ID** shown

#### 3.4 Get Team ID
1. Go to https://developer.apple.com/account
2. Your **Team ID** is shown in the top right corner

#### 3.5 Add Credentials to Supabase
1. Back in Supabase Dashboard → **Authentication** → **Providers** → **Apple**
2. Enter:
   - **Services ID**: `com.sportsiq.auth` (from step 3.2)
   - **Team ID**: Your team ID (from step 3.4)
   - **Key ID**: The key ID from step 3.3
   - **Private Key**: Open the .p8 file in a text editor, copy the entire contents
3. Click **Save**

### Step 4: Enable Google Sign In

1. In **Providers** tab, find **Google**
2. Toggle **Google Enabled** to ON
3. You'll need Google OAuth credentials:
   - **Client ID**
   - **Client Secret**

**Google Cloud Setup** (detailed steps):

#### 4.1 Create Google Cloud Project
1. Go to https://console.cloud.google.com
2. Create a new project or select existing
3. Name it `SportsIQ`

#### 4.2 Configure OAuth Consent Screen
1. Navigate to **APIs & Services** → **OAuth consent screen**
2. Select **External** → **Create**
3. Fill in:
   - App name: `SportsIQ`
   - User support email: Your email
   - Developer contact: Your email
4. Click **Save and Continue**
5. **Scopes**: Click **Add or Remove Scopes**
   - Add: `userinfo.email`, `userinfo.profile`
6. Click **Save and Continue**
7. **Test users** (optional for development)
8. Click **Save and Continue**

#### 4.3 Create OAuth Credentials
1. Navigate to **APIs & Services** → **Credentials**
2. Click **+ Create Credentials** → **OAuth client ID**
3. Application type: **iOS**
4. Name: `SportsIQ iOS`
5. **Bundle ID**: `com.sportsiq.app` (your iOS bundle ID)
6. Click **Create**
7. **Also create Web Application** (needed for Supabase):
   - Click **+ Create Credentials** → **OAuth client ID** again
   - Application type: **Web application**
   - Name: `SportsIQ Supabase`
   - **Authorized redirect URIs**: Add `https://gzghfnqpzjmcsenrnjme.supabase.co/auth/v1/callback`
   - Click **Create**
8. Copy the **Client ID** and **Client Secret** from the **Web application**

#### 4.4 Add Credentials to Supabase
1. Back in Supabase Dashboard → **Authentication** → **Providers** → **Google**
2. Enter:
   - **Client ID**: The Web application client ID
   - **Client Secret**: The Web application client secret
3. Click **Save**

#### 4.5 Add Google iOS Client ID to Xcode
1. Copy the **iOS Client ID** from Google Cloud Console
2. You'll add this to your app's `Info.plist` later
3. Also add URL scheme: Reverse of client ID (e.g., `com.googleusercontent.apps.123456789`)

---

## Part 2: Configure Row Level Security (RLS)

Supabase uses Row Level Security to ensure users can only access their own data.

### Step 1: Enable RLS on Tables

1. In Supabase Dashboard, go to **Table Editor**
2. For each table that contains user data, enable RLS:
   - `users`
   - `user_progress`
   - `submissions`
   - `user_xp_events`
   - `user_badges`
   - `user_streaks`
   - `srs_cards`
   - `srs_reviews`
   - `sessions`
   - `devices`
   - `friends`
   - `live_submissions`

3. For each table:
   - Click the table name
   - Click **RLS** toggle to enable
   - Or run SQL:
     ```sql
     ALTER TABLE users ENABLE ROW LEVEL SECURITY;
     ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
     ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
     -- ... etc for all user tables
     ```

### Step 2: Create RLS Policies

Run this SQL in the Supabase SQL Editor to create policies:

```sql
-- Users table: Users can read and update their own data
CREATE POLICY "Users can view own profile"
  ON users FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id);

-- User progress: Users can view and update their own progress
CREATE POLICY "Users can view own progress"
  ON user_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own progress"
  ON user_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- Submissions: Users can insert and view their own submissions
CREATE POLICY "Users can create own submissions"
  ON submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own submissions"
  ON submissions FOR SELECT
  USING (auth.uid() = user_id);

-- XP Events: Users can view their own XP
CREATE POLICY "Users can view own xp events"
  ON user_xp_events FOR SELECT
  USING (auth.uid() = user_id);

-- Badges: Users can view their own badges
CREATE POLICY "Users can view own badges"
  ON user_badges FOR SELECT
  USING (auth.uid() = user_id);

-- Streaks: Users can view their own streaks
CREATE POLICY "Users can view own streaks"
  ON user_streaks FOR SELECT
  USING (auth.uid() = user_id);

-- SRS Cards: Users can view and update their own cards
CREATE POLICY "Users can view own srs cards"
  ON srs_cards FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own srs cards"
  ON srs_cards FOR UPDATE
  USING (auth.uid() = user_id);

-- SRS Reviews: Users can create and view their own reviews
CREATE POLICY "Users can create own reviews"
  ON srs_reviews FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own reviews"
  ON srs_reviews FOR SELECT
  USING (auth.uid() = user_id);

-- Sessions: Users can view their own sessions
CREATE POLICY "Users can view own sessions"
  ON sessions FOR SELECT
  USING (auth.uid() = user_id);

-- Devices: Users can view and update their own devices
CREATE POLICY "Users can view own devices"
  ON devices FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can update own devices"
  ON devices FOR UPDATE
  USING (auth.uid() = user_id);

-- Friends: Users can view and manage their own friendships
CREATE POLICY "Users can view own friends"
  ON friends FOR SELECT
  USING (auth.uid() = user_id OR auth.uid() = friend_id);

CREATE POLICY "Users can create own friendships"
  ON friends FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Live submissions: Users can create and view their own live submissions
CREATE POLICY "Users can create own live submissions"
  ON live_submissions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view own live submissions"
  ON live_submissions FOR SELECT
  USING (auth.uid() = user_id);

-- Public read access for non-user-specific tables
CREATE POLICY "Anyone can view sports"
  ON sports FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view leagues"
  ON leagues FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view teams"
  ON teams FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view modules"
  ON modules FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view lessons"
  ON lessons FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view items"
  ON items FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view concepts"
  ON concepts FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view badges"
  ON badges FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view games"
  ON games FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view plays"
  ON plays FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view live prompts"
  ON live_prompts FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view live prompt windows"
  ON live_prompt_windows FOR SELECT
  USING (true);

CREATE POLICY "Anyone can view leaderboards"
  ON leaderboards FOR SELECT
  USING (true);
```

---

## Part 3: Update Xcode Project (Info.plist)

After configuring providers, you need to add URL schemes to your iOS app.

### Add URL Schemes to Info.plist

You'll need to manually add these in Xcode:

1. Open your Xcode project
2. Select the **SportsIQ** target
3. Go to **Info** tab
4. Expand **URL Types**
5. Add the following URL schemes:

**For Supabase:**
- Identifier: `com.sportsiq.supabase`
- URL Schemes: `com.sportsiq.app` (your bundle ID)

**For Google Sign In:**
- Identifier: `com.sportsiq.google`
- URL Schemes: `com.googleusercontent.apps.YOUR_IOS_CLIENT_ID` (reversed iOS client ID from Google)

**For Apple Sign In:**
- No URL scheme needed - handled automatically by iOS

---

## Part 4: Test Authentication (After Code Implementation)

Once the AuthService is implemented, test:

### Email/Password
1. Sign up with a test email
2. Check Supabase Dashboard → **Authentication** → **Users**
3. Verify user appears
4. Sign out
5. Sign in again with same credentials

### Apple Sign In
1. Tap "Sign in with Apple"
2. Use your Apple ID
3. Complete the flow
4. Verify user appears in Supabase

### Google Sign In
1. Tap "Sign in with Google"
2. Select Google account
3. Grant permissions
4. Verify user appears in Supabase

### Session Persistence
1. Sign in
2. Close app completely
3. Reopen app
4. Verify you're still signed in

---

## Troubleshooting

### Email Auth Not Working
- Check Supabase logs: Dashboard → **Logs**
- Verify email provider is enabled
- Check email templates are configured

### Apple Sign In Fails
- Verify all Apple Developer credentials are correct
- Check Services ID matches exactly
- Ensure return URL is correct in Apple Developer
- Check .p8 private key was copied correctly

### Google Sign In Fails
- Verify OAuth credentials are correct
- Check redirect URI matches in Google Cloud Console
- Ensure both iOS and Web credentials are created
- Test with a Google account (not G Suite if restricted)

### RLS Blocks Requests
- Check user is authenticated (`auth.uid()` is not null)
- Verify policies exist for the table
- Check policy logic matches your use case
- Temporarily disable RLS to test (re-enable after!)

### Token Expired
- Supabase handles auto-refresh
- Check `authStateChange` listener is set up
- Verify session is stored securely

---

## Next Steps

After completing this manual setup:

1. ✅ Auth providers configured in Supabase
2. ✅ RLS policies created
3. ✅ URL schemes added to Xcode
4. ⏭️ Implement `AuthService.swift` (automated)
5. ⏭️ Implement UI (LoginView, SignUpView)
6. ⏭️ Add auth state management
7. ⏭️ Test end-to-end flow

---

**You're now ready to implement the authentication code!**
