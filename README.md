# SwiftSound

A NetEase Cloud Music-inspired macOS music player clone built with SwiftUI. This is a study project for recreating a high-fidelity native desktop music experience, not an official NetEase Cloud Music client.

## Tech Stack

| Layer                | Technology                                           |
| -------------------- | ---------------------------------------------------- |
| **Platform**         | macOS                                                |
| **Language/UI**      | Swift, SwiftUI                                       |
| **Minimum Target**   | macOS 26.x, as configured in `SwiftSound.xcodeproj` |
| **State**            | Combine, `ObservableObject`, app-level stores        |
| **Networking**       | async/await, Alamofire, typed API requests           |
| **Media**            | AVFoundation, Kingfisher                             |
| **Caching**          | Cache, custom API response cache                     |

## Architecture

```text
SwiftSound/
+-- App/                  # Entry, shell, routing, sidebar, toolbar, player
+-- Features/             # Featured, NewMusic, playlist, ranking, and placeholder pages
+-- Data/                 # Models, typed requests, repositories
+-- Shared/               # Core networking/config, design system, reusable UI
+-- Resources/            # Asset catalogs

design/                   # NetEase Cloud Music reference screenshots
SwiftSoundTests/          # Request/model/parser tests and JSON fixtures
SwiftSoundUITests/        # UI test target
```

## Configuration

SwiftSound uses a compatible NeteaseCloudMusicApi service. The default development endpoint is `http://localhost:5001`.

```env
SWIFTSOUND_API_ENVIRONMENT=development
SWIFTSOUND_API_BASE_URL=http://localhost:5001
```

| Environment | Default Base URL |
| --- | --- |
| `development` | `http://localhost:5001` |
| `staging` | `https://staging-api.swiftsound.app` |
| `production` | `https://api.swiftsound.app` |

## Credits

API provided by [NeteaseCloudMusicApi](https://github.com/Jinchao1926/NeteaseCloudMusicApi).
