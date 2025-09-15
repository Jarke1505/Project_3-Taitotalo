// Simple Restaurant Backend Server
// This bypasses all npm/TypeScript issues and just works

const http = require('http');
const url = require('url');
const fs = require('fs');
const path = require('path');

// Simple in-memory data store
let users = [
    { id: 1, username: 'admin', password: 'admin123', email: 'admin@restaurant.com' }
];

let orders = [];
let contactMessages = [];
let menu = [
    { id: 1, name: 'Salmon Sushi', price: 18.99, description: 'Fresh Atlantic salmon with premium rice and seaweed' },
    { id: 2, name: 'Caesar Salad', price: 12.99, description: 'Crisp romaine lettuce with parmesan and croutons' },
    { id: 3, name: 'Pasta Carbonara', price: 16.99, description: 'Creamy pasta with bacon and parmesan cheese' },
    { id: 4, name: 'Margherita Pizza', price: 14.99, description: 'Classic pizza with tomato, mozzarella, and basil' },
    { id: 5, name: 'Grilled Steak', price: 24.99, description: 'Tender beef steak cooked to perfection' },
    { id: 6, name: 'Chocolate Cake', price: 8.99, description: 'Rich chocolate cake with vanilla ice cream' }
];

// CORS headers
const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization'
};

// Helper function to send JSON response
function sendJSON(res, data, statusCode = 200) {
    res.writeHead(statusCode, { ...corsHeaders, 'Content-Type': 'application/json' });
    res.end(JSON.stringify(data));
}

// Helper function to send HTML response
function sendHTML(res, content, statusCode = 200) {
    res.writeHead(statusCode, { ...corsHeaders, 'Content-Type': 'text/html' });
    res.end(content);
}

// Helper function to parse POST data
function parsePostData(req, callback) {
    let body = '';
    req.on('data', chunk => {
        body += chunk.toString();
    });
    req.on('end', () => {
        try {
            const data = JSON.parse(body);
            callback(data);
        } catch (e) {
            callback(null);
        }
    });
}

// Main server handler
const server = http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url, true);
    const pathname = parsedUrl.pathname;
    const method = req.method;

    console.log(`${method} ${pathname}`);

    // Handle CORS preflight
    if (method === 'OPTIONS') {
        res.writeHead(200, corsHeaders);
        res.end();
        return;
    }

    // Serve static files (CSS, JS, images)
    if (pathname.endsWith('.css')) {
        try {
            const cssContent = fs.readFileSync(path.join(__dirname, pathname), 'utf8');
            res.writeHead(200, { ...corsHeaders, 'Content-Type': 'text/css' });
            res.end(cssContent);
        } catch (e) {
            res.writeHead(404, corsHeaders);
            res.end('CSS file not found');
        }
        return;
    }

    if (pathname.endsWith('.js')) {
        try {
            const jsContent = fs.readFileSync(path.join(__dirname, pathname), 'utf8');
            res.writeHead(200, { ...corsHeaders, 'Content-Type': 'application/javascript' });
            res.end(jsContent);
        } catch (e) {
            res.writeHead(404, corsHeaders);
            res.end('JavaScript file not found');
        }
        return;
    }

    if (pathname.endsWith('.svg') || pathname.endsWith('.jpg') || pathname.endsWith('.jpeg') || pathname.endsWith('.png') || pathname.endsWith('.gif')) {
        try {
            const imageContent = fs.readFileSync(path.join(__dirname, pathname));
            const contentType = pathname.endsWith('.svg') ? 'image/svg+xml' : 
                              pathname.endsWith('.jpg') || pathname.endsWith('.jpeg') ? 'image/jpeg' :
                              pathname.endsWith('.png') ? 'image/png' : 'image/gif';
            res.writeHead(200, { ...corsHeaders, 'Content-Type': contentType });
            res.end(imageContent);
        } catch (e) {
            res.writeHead(404, corsHeaders);
            res.end('Image file not found');
        }
        return;
    }

    // Serve main page
    if (pathname === '/' || pathname === '/index.html') {
        try {
            const htmlContent = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');
            sendHTML(res, htmlContent);
        } catch (e) {
            sendHTML(res, '<h1>Restaurant App</h1><p>Frontend files not found. Please make sure index.html exists.</p>', 404);
        }
        return;
    }

    // Serve admin dashboard
    if (pathname === '/admin' || pathname === '/admin.html') {
        try {
            const htmlContent = fs.readFileSync(path.join(__dirname, 'admin_dashboard.html'), 'utf8');
            sendHTML(res, htmlContent);
        } catch (e) {
            sendHTML(res, '<h1>Admin Dashboard</h1><p>Admin dashboard not found. Please make sure admin_dashboard.html exists.</p>', 404);
        }
        return;
    }

    // Serve contact page
    if (pathname === '/contact' || pathname === '/contact.html') {
        try {
            const htmlContent = fs.readFileSync(path.join(__dirname, 'contact.html'), 'utf8');
            sendHTML(res, htmlContent);
        } catch (e) {
            sendHTML(res, '<h1>Contact</h1><p>Contact page not found. Please make sure contact.html exists.</p>', 404);
        }
        return;
    }

    // Serve menu page
    if (pathname === '/menu' || pathname === '/menu.html') {
        try {
            const htmlContent = fs.readFileSync(path.join(__dirname, 'menu.html'), 'utf8');
            sendHTML(res, htmlContent);
        } catch (e) {
            sendHTML(res, '<h1>Menu</h1><p>Menu page not found. Please make sure menu.html exists.</p>', 404);
        }
        return;
    }

    // API Routes
    if (pathname.startsWith('/api/')) {
        // Health check
        if (pathname === '/api/health') {
            sendJSON(res, { status: 'OK', message: 'Restaurant API is running' });
            return;
        }

        // Get menu
        if (pathname === '/api/menu' && method === 'GET') {
            sendJSON(res, { menu });
            return;
        }

        // User login
        if (pathname === '/api/login' && method === 'POST') {
            parsePostData(req, (data) => {
                if (!data || !data.username || !data.password) {
                    sendJSON(res, { error: 'Username and password required' }, 400);
                    return;
                }

                const user = users.find(u => u.username === data.username && u.password === data.password);
                if (user) {
                    // Simple token (in real app, use JWT)
                    const token = Buffer.from(`${user.username}:${Date.now()}`).toString('base64');
                    sendJSON(res, { 
                        success: true, 
                        token, 
                        user: { id: user.id, username: user.username, email: user.email }
                    });
                } else {
                    sendJSON(res, { error: 'Invalid credentials' }, 401);
                }
            });
            return;
        }

        // User registration
        if (pathname === '/api/register' && method === 'POST') {
            parsePostData(req, (data) => {
                if (!data || !data.username || !data.password || !data.email) {
                    sendJSON(res, { error: 'Username, password, and email required' }, 400);
                    return;
                }

                const existingUser = users.find(u => u.username === data.username);
                if (existingUser) {
                    sendJSON(res, { error: 'Username already exists' }, 400);
                    return;
                }

                const newUser = {
                    id: users.length + 1,
                    username: data.username,
                    password: data.password,
                    email: data.email
                };
                users.push(newUser);

                sendJSON(res, { 
                    success: true, 
                    user: { id: newUser.id, username: newUser.username, email: newUser.email }
                });
            });
            return;
        }

        // Create order
        if (pathname === '/api/orders' && method === 'POST') {
            parsePostData(req, (data) => {
                console.log('Received order data:', data);
                
                if (!data || !data.items || !Array.isArray(data.items)) {
                    sendJSON(res, { error: 'Order items required' }, 400);
                    return;
                }

                const order = {
                    id: orders.length + 1,
                    orderId: 'ORD-' + Date.now(),
                    customer: data.customer || {},
                    items: data.items,
                    total: data.total || data.items.reduce((sum, item) => sum + (item.price * (item.qty || item.quantity || 1)), 0),
                    payment: data.payment || 'Online Payment',
                    status: 'paid',
                    createdAt: data.timestamp || new Date().toISOString()
                };
                orders.push(order);

                console.log(`🍽️ New order #${order.orderId} from ${order.customer.name || 'Unknown'}`);
                console.log(`   Total: €${order.total.toFixed(2)}`);
                console.log(`   Items: ${order.items.length} items`);

                sendJSON(res, { success: true, order, orderId: order.orderId });
            });
            return;
        }

        // Get orders
        if (pathname === '/api/orders' && method === 'GET') {
            sendJSON(res, { orders });
            return;
        }

        // Submit contact message
        if (pathname === '/api/contact' && method === 'POST') {
            parsePostData(req, (data) => {
                if (!data || !data.name || !data.email || !data.message) {
                    sendJSON(res, { error: 'Name, email, and message are required' }, 400);
                    return;
                }

                const contactMessage = {
                    id: contactMessages.length + 1,
                    name: data.name,
                    email: data.email,
                    message: data.message,
                    createdAt: new Date().toISOString(),
                    status: 'new'
                };
                contactMessages.push(contactMessage);

                console.log(`📧 New contact message from ${data.name} (${data.email})`);
                console.log(`   Message: ${data.message}`);

                sendJSON(res, { 
                    success: true, 
                    message: 'Contact message sent successfully!',
                    messageId: contactMessage.id
                });
            });
            return;
        }

        // Get contact messages (for admin viewing)
        if (pathname === '/api/contact' && method === 'GET') {
            sendJSON(res, { messages: contactMessages });
            return;
        }

        // 404 for unknown API routes
        sendJSON(res, { error: 'API endpoint not found' }, 404);
        return;
    }

    // 404 for other routes
    sendHTML(res, '<h1>404 - Page Not Found</h1>', 404);
});

const PORT = 4000;
server.listen(PORT, () => {
    console.log(`🍽️  Restaurant Backend Server running on http://localhost:${PORT}`);
    console.log(`📋  API endpoints available at http://localhost:${PORT}/api/`);
    console.log(`🌐  Frontend available at http://localhost:${PORT}/`);
    console.log(`\nPress Ctrl+C to stop the server`);
});

// Handle server errors
server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
        console.log(`❌ Port ${PORT} is already in use. Please close other applications using this port.`);
    } else {
        console.log(`❌ Server error: ${err.message}`);
    }
    process.exit(1);
});
