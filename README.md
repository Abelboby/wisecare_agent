# WiseAgent

![Flutter](https://img.shields.io/badge/Flutter-App-blue)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![Role](https://img.shields.io/badge/User-Agent-red)

The app that turns "someone should handle this" into "done".

WiseAgent helps care agents pick tasks fast, move confidently, and keep families informed in real time.

## Live Demo

- [WiseAgent](https://wisecareagent.vercel.app)

## Quick Nav

- [What It Does](#what-it-does)
- [Main Screens](#main-screens)
- [How It Works](#how-it-works)
- [For Geeks and Nerds](#for-geeks-and-nerds)
- [A Short Story](#a-short-story)

## What It Does

- Shows assigned service requests for the logged-in agent
- Lets agents update request status from assignment to completion
- Gives map context for faster action
- Supports profile updates without leaving the app flow

## Main Screens

| Tasks | Task Detail | Map |
|---|---|---|
| ![Home Screen](./screenshots/home_screen.png) | ![Task Detail Screen](./screenshots/task_detail_screen.png) | ![Map Screen](./screenshots/maps_screen.png) |

## How It Works

```mermaid
flowchart LR
    A[WiseAgent App] --> B[GET /service-requests]
    B --> C[Agent picks a task]
    C --> D[PATCH /service-requests/{id}/status]
    D --> E[Everyone sees updated progress]
```

Fast loop, clear ownership, fewer missed handoffs.

## For Geeks and Nerds

If you want architecture, API methods, flow details, and the full screen gallery, read [DETAILED.md](./DETAILED.md).

## A Short Story

Priya starts her shift and sees a new request from an elderly user who needs urgent medicine pickup.

She accepts it in one tap, checks location details, and marks progress while moving. The family side sees updates without calling five different people.

That is WiseAgent in one line: less confusion, faster response, better care.
