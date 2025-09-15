# Restaurant Backend (Express + TypeScript + Mongoose)

## Setup
1. Install Node 18+
2. Create a `.env` in this folder with:
```
PORT=4000
MONGO_URI=mongodb://localhost:27017/restaurant_app
JWT_SECRET=super_secret_change_me
```
3. Install deps:
```
npm install
```
4. Run dev server:
```
npm run dev
```

## APIs
- GET `/api/health` → `{ "status": "ok" }`
- POST `/api/auth/register` → `{ token }`
- POST `/api/auth/login` → `{ token }`
- GET `/api/user/profile` (Authorization: Bearer <token>) → `{ user }`

## Structure
```
src/
  index.ts
  app.ts
  routes/
    health.routes.ts
    auth.routes.ts
    user.routes.ts
  controllers/
    auth.controller.ts
    user.controller.ts
  models/
    user.model.ts
  middleware/
    auth.ts
    error.ts
```


