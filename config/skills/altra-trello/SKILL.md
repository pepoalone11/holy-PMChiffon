---
name: altra-trello
description: Manage and sync tasks on the AltraRich-Dev Trello board (board JHFq63IG) — read card details, check acceptance criteria, move lanes, and post progress comments. Trigger on /altra-trello, altra-trello, /card, /lane, หรือ "ดูการ์ด altrarich / อัปเดต trello altrarich".
---

# Altra Trello — AltraRich-Dev Board Manager

Integrates with the **AltraRich-Dev** Trello Board (`https://trello.com/b/JHFq63IG/altrarich-dev`).

## 🎯 Scope & Triggers
Trigger when:
- User asks `/altra-trello`, `/card`, `/lane`, `altra-trello`, หรือ "ดูการ์ด altrarich / อัปเดต trello"
- Reading card specifications, acceptance criteria, or moving cards through workflow lanes.

---

## 🔑 Credentials Management
Credentials are stored securely in the macOS Keychain:
```bash
KEY=$(security find-generic-password -a trello-altrarich -s trello-api -w 2>/dev/null)
TOKEN=$(security find-generic-password -a trello-altrarich -s trello-token -w 2>/dev/null)
```
> If keys are missing, ask the user to add them via:
> ```bash
> security add-generic-password -a trello-altrarich -s trello-api -w '<KEY>' -U
> security add-generic-password -a trello-altrarich -s trello-token -w '<TOKEN>' -U
> ```

---

## 🏃 Workflow Lanes
Lanes follow this progression:
`Backlog` ➔ `Sprint` ➔ `WIP` ➔ `Committed` ➔ `PR` ➔ `Dev-Site` ➔ `Testing` ➔ `Done` ➔ `Production`

### Operations
1. **Fetch Board Lanes:**
   `https://api.trello.com/1/boards/JHFq63IG/lists?key=$KEY&token=$TOKEN`
2. **Read Card Details:**
   `https://api.trello.com/1/cards/<cardId>?attachments=true&key=$KEY&token=$TOKEN`
3. **Move Card:**
   `PUT https://api.trello.com/1/cards/<cardId>?idList=<targetListId>&key=$KEY&token=$TOKEN`
4. **Post Comment:**
   `POST https://api.trello.com/1/cards/<cardId>/actions/comments?text=<urlEncodedComment>&key=$KEY&token=$TOKEN`
