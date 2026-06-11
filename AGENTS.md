# AGENTS.md

## Project Overview

SwiftSound is a SwiftUI macOS app inspired by NetEase Cloud Music for Mac. The goal is to study and recreate the desktop music player experience with a high-fidelity native macOS implementation.

## Tech Stack

- Language: Swift
- UI framework: SwiftUI
- Reactive framework preference: Combine
- Platform: macOS
- Project type: Xcode project
- Minimum macOS target: macOS 26.x, as configured in `SwiftSound/SwiftSound.xcodeproj`

## Repository Structure

- `design`: Reference screenshots for the NetEase Music-inspired UI.

## Development Guidelines

- Follow existing SwiftUI conventions in nearby files.
- Prefer Combine for app state and event streams when reactive behavior is needed.
- Keep changes focused on the requested feature or fix.
- Avoid broad refactors unless they are necessary for the requested work.
- Do not add third-party dependencies without a clear need.
- Do not change bundle identifiers, signing settings, deployment targets, or project-level build settings unless explicitly requested.

## UI and Design Guidelines

- Use the screenshots in `design/` as the primary visual reference.
- Match the macOS NetEase Cloud Music style as closely as practical.
- Prioritize native SwiftUI controls and macOS behavior.
- Keep layout, spacing, typography, and interaction states consistent across screens.
- Define custom SwiftUI colors with HEX values in the shared theme extensions.
- Avoid placeholder UI once a referenced design exists.

## Testing

- Do not add or expand tests unless explicitly requested.
- Existing generated test targets may remain in place.
- If a task requires verification, prefer building the app with `xcodebuild`.

## Agent Notes

- Read this file before making changes.
- Check the relevant design screenshot before implementing UI.
- Preserve user changes in the working tree.
- If requirements are unclear, make a conservative assumption and state it in the final response.
