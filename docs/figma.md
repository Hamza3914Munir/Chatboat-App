# Figma design link (FacePix)

This project implements UI from the **AI editing app** Figma file.

| Field | Value |
|-------|--------|
| Design file | [AI editing app](https://www.figma.com/design/JfobKGsvpE1qxTZMWFcxha/AI-editing-app) |
| `fileKey` | `JfobKGsvpE1qxTZMWFcxha` |
| Default node | `0:1` (file root) |

## Screens in scope

| Screen | Notes |
|--------|--------|
| Splash | White background, centered FacePix logo |
| Onboarding 1 | Yellow — “Perfect for Face frame Setup!” |
| Onboarding 2 | Coral — “Make every shot better!” |
| Onboarding 3 | Purple — “Create fun face edits!” |
| Onboarding 4 | Pink — “Enhance photos and videos!” |
| Create account | White — sign up form (`2183:33`) |
| Email verification | White — verify email after sign up (`2201:198`) |
| Login | White — welcome back form (`2185:264`) |
| Forgot password | White — reset link form (`2197:146`) |
| AI data sharing | Dialog over home — first launch (`2201:249`) |
| Home | Shell tab 1 (`2221:132`) |
| Templates | Pushed from Home; All / Images / Videos states (`2229:863`, `2230:1060`, `2230:1259`) |
| History | Shell tab 2 (`2304:1023`) |
| Profile | Shell tab 3 (`2312:95`) |

## Generation flows

Four flows share one skeleton; `lib/features/generate/models/generation_flow.dart`
holds the per-flow copy and style lists, and the screens are parameterised by it.
Step order is taken from the Figma prototype links, not guessed.

| Flow | Style | Customize | Upload | Generating | Result |
|------|-------|-----------|--------|------------|--------|
| Avatar | `2256:2` | — | `2267:2` | `2274:118` | `2279:2` |
| Portrait | `2282:189` | `2284:682` | `2283:386` | `2283:531` | `2283:589` |
| ID Photo | `2289:1044` | `2292:134` | `2289:1149` | `2289:1304` | `2289:1364` |
| Video | `2294:466` | `2299:870` | `2295:568` | `2295:728` | `2295:784` |

`Choose Category` (`2251:549`) feeds all four: 7 categories map onto 4 flows
(Professional Photos → Portrait; Animated Photos, Cinematic Clips and Profile
Videos → Video). Error (`2271:2` + twins) branches off Upload. Templates enter
through `Tem Preview` (`2236:1921`).

## Font substitutions

Figma reports `Liberation Serif`, `Liberation Sans`, `FreeSans` and `FreeSerif`
on some layers. Those are the substitution set Figma falls back to when a font
is unavailable, so they are rendered as **Plus Jakarta Sans**. `Manrope` is not
in that set — it is genuinely specified, and is used for the error headline and
the Customize Video title.

## Not in scope (superseded)

`Choose Style Screen` (`2005:541`), `Profile Screen` (`2005:823`) and `Frame` (`2045:193`) are an older
iteration — they use a different bottom nav and the previous "Famepix" brand name. Skip them.

## Pulling design data

The Figma MCP server is capped at 20 calls/month on a View seat, so design data is pulled over the
REST API instead, using a token in `.env.local` (gitignored):

```bash
export $(grep -E '^FIGMA_TOKEN=' .env.local | xargs)
curl -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/files/JfobKGsvpE1qxTZMWFcxha/nodes?ids=2221:132&geometry=paths"
```

`/v1/images` (node renders) is aggressively rate limited. Two alternatives that are not:
`/v1/files/:key/images` returns every image fill by `imageRef`, and vector icons can be written
straight out of the `fillGeometry` path data that `geometry=paths` returns.

## Cursor + Figma MCP

1. Install the Figma plugin in Cursor (`/add-plugin figma` or Marketplace).
2. Open **Cursor Settings → Tools & MCP** and click **Authenticate** for Figma.
3. Optional manual server: `{ "mcpServers": { "Figma": { "url": "https://mcp.figma.com/mcp" } } }`

Agents should call `get_design_context` with `fileKey` and per-screen `nodeId` (and `skillNames: figma-design-to-code`) to export assets and exact tokens.

## Onboarding illustration exports

1. Export each 3D character from Figma as **PNG** (white background is fine).
2. Copy into [`assets/onboarding/source/`](assets/onboarding/source/) as `onboarding_1_source.png` … `onboarding_4_source.png` (same files as in Downloads).
3. Run from project root:

   ```bash
   python3 tooling/process_onboarding_assets.py
   ```

4. Commit the generated [`assets/onboarding/onboarding_1.png`](assets/onboarding/onboarding_1.png) … `onboarding_4.png`.

Processing uses **corner flood-fill** only (see [`tooling/process_onboarding_assets.py`](../tooling/process_onboarding_assets.py)). A global black/white key destroys black hair and boot details on colored screen backgrounds.
