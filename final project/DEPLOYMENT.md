# 🚀 Deployment Guide

This guide will help you deploy your Amber & Thyme restaurant website to various hosting platforms.

## 📋 Prerequisites

- Node.js installed on your system
- Git installed
- GitHub account (for GitHub Pages)
- Web hosting account (for full deployment)

## 🌐 Option 1: GitHub Pages (Frontend Only)

**Note**: This option only hosts the frontend. The backend features (ordering, admin dashboard) won't work.

### Steps:
1. Create a new repository on GitHub
2. Upload all files to the repository
3. Go to repository Settings → Pages
4. Select "Deploy from a branch" → "main" → "root"
5. Your site will be available at `https://yourusername.github.io/repository-name`

### Files to include:
- `index.html`
- `menu.html` (frontend only)
- `contact.html`
- `restaurant.css`
- `restaurant.js`
- `order.js`
- `images/` folder
- `README.md`

## 🌐 Option 2: Full Deployment (Recommended)

This option includes both frontend and backend, so all features work.

### Heroku
1. Create a `Procfile` with: `web: node simple_backend.js`
2. Add `"engines": {"node": "18.x"}` to package.json
3. Deploy via Heroku CLI or GitHub integration

### Vercel
1. Install Vercel CLI: `npm i -g vercel`
2. Run `vercel` in your project directory
3. Follow the prompts

### Netlify
1. Connect your GitHub repository
2. Set build command: `node simple_backend.js`
3. Set publish directory: `.`

### DigitalOcean App Platform
1. Connect your GitHub repository
2. Select Node.js as the runtime
3. Set start command: `node simple_backend.js`

### Traditional Web Hosting
1. Upload all files to your web server
2. Install Node.js on the server
3. Run `node simple_backend.js`
4. Configure your domain

## 🔧 Configuration

### Environment Variables
Create a `.env` file for configuration:
```
PORT=4000
NODE_ENV=production
```

### Domain Setup
1. Point your domain to your hosting provider
2. Configure SSL certificate
3. Update any hardcoded URLs if needed

## 📱 Mobile Optimization

The website is already responsive, but you can further optimize:
- Test on various devices
- Optimize images
- Enable compression
- Use CDN for static assets

## 🔒 Security Considerations

- Change default admin credentials
- Implement proper authentication
- Add rate limiting
- Use HTTPS
- Validate all inputs

## 📊 Monitoring

- Set up error tracking (Sentry, LogRocket)
- Monitor server performance
- Track user analytics
- Set up uptime monitoring

## 🆘 Troubleshooting

### Common Issues:
1. **Port already in use**: Change PORT in simple_backend.js
2. **CORS errors**: Check server configuration
3. **Static files not loading**: Verify file paths
4. **Orders not saving**: Check backend logs

### Support:
- Check server logs for errors
- Test API endpoints manually
- Verify file permissions
- Check network connectivity

## 🎯 Next Steps

After deployment:
1. Test all functionality
2. Set up monitoring
3. Configure backups
4. Plan for scaling
5. Add analytics

---

**Happy Deploying!** 🚀✨
