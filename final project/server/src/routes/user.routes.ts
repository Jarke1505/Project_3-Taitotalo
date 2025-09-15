import { Router } from 'express';
import { getProfile } from '../controllers/user.controller';
import { requireAuth } from '../middleware/auth';

const router = Router();

router.get('/profile', requireAuth, getProfile);

export default router;


