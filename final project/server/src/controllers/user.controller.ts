import { Request, Response } from 'express';
import { User } from '../models/user.model';

export async function getProfile(req: Request, res: Response) {
  const userId = (req as any).userId as string;
  const user = await User.findById(userId).select('-passwordHash');
  if (!user) return res.status(404).json({ message: 'Not found' });
  res.json({ user });
}


