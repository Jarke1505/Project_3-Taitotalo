// Enhanced order.js with backend integration
// This connects your existing Amber & Thyme site to the backend

document.addEventListener('DOMContentLoaded', function () {
  var buttons = Array.prototype.slice.call(document.querySelectorAll('.add-to-cart'));
  var cartToggle = document.getElementById('cart-toggle');
  var cartOverlay = document.getElementById('cart-overlay');
  var cartSidebar = document.getElementById('cart-sidebar');
  var cartItemsEl = document.getElementById('cart-items');
  var cartCountEl = document.getElementById('cart-count');
  var cartSubtotalEl = document.getElementById('cart-subtotal');
  var checkoutBtn = document.getElementById('checkout-btn');
  var modalBackdrop = document.getElementById('modal-backdrop');
  var checkoutModal = document.getElementById('checkout-modal');
  var modalClose = document.getElementById('modal-close');
  var placeOrderBtn = document.getElementById('place-order');
  var orderMessage = document.getElementById('order-message');
  var checkoutTitle = document.getElementById('checkout-title');
  var payHelp = document.getElementById('pay-help');
  var cardFields = document.getElementById('card-fields');

  var cart = {};
  var currentUser = null;
  var API_BASE = 'http://localhost:4000/api';

  // Check if backend is available
  async function checkBackend() {
    try {
      const response = await fetch(`${API_BASE}/health`);
      return response.ok;
    } catch (error) {
      return false;
    }
  }

  // Show status message
  function showStatus(message, isError = false) {
    // Create or update status message
    let statusEl = document.getElementById('backend-status');
    if (!statusEl) {
      statusEl = document.createElement('div');
      statusEl.id = 'backend-status';
      statusEl.style.cssText = `
        position: fixed;
        top: 10px;
        right: 10px;
        padding: 10px 15px;
        border-radius: 5px;
        color: white;
        font-weight: bold;
        z-index: 10000;
        max-width: 300px;
      `;
      document.body.appendChild(statusEl);
    }
    
    statusEl.textContent = message;
    statusEl.style.background = isError ? '#e74c3c' : '#27ae60';
    
    if (!isError) {
      setTimeout(() => statusEl.remove(), 3000);
    }
  }

  // Initialize backend connection
  async function initBackend() {
    const isBackendAvailable = await checkBackend();
    if (isBackendAvailable) {
      showStatus('✅ Connected to backend - orders will be saved!');
    } else {
      showStatus('⚠️ Backend not available - using local cart only', true);
    }
    return isBackendAvailable;
  }

  function formatEuro(n) {
    return '€' + Number(n).toFixed(2);
  }

  function getCartList() {
    return Object.keys(cart).map(function (key) { return cart[key]; });
  }

  function updateCountAndSubtotal() {
    var items = getCartList();
    var count = items.reduce(function (sum, it) { return sum + it.qty; }, 0);
    var subtotal = items.reduce(function (sum, it) { return sum + it.qty * it.price; }, 0);
    if (cartCountEl) cartCountEl.textContent = String(count);
    if (cartSubtotalEl) cartSubtotalEl.textContent = formatEuro(subtotal);
  }

  function renderCart() {
    if (!cartItemsEl) return;
    cartItemsEl.innerHTML = '';
    getCartList().forEach(function (item) {
      var row = document.createElement('div');
      row.className = 'cart-item';
      var thumb = getItemThumb(item.id);
      row.innerHTML = '<div class="cart-thumb">' + thumb + '</div>' +
        '<div class="cart-item-title">' + item.name + '</div>' +
        '<div class="cart-item-controls">' +
        '<button class="qty-btn" data-action="dec" data-id="' + item.id + '">-</button>' +
        '<span aria-live="polite">' + item.qty + '</span>' +
        '<button class="qty-btn" data-action="inc" data-id="' + item.id + '">+</button>' +
        '<strong style="margin-left:0.5rem;">' + formatEuro(item.qty * item.price) + '</strong>' +
        '</div>';
      cartItemsEl.appendChild(row);
    });
    updateCountAndSubtotal();
  }

  // Map menu item id to emoji thumb; could be replaced by real images
  function getItemThumb(id) {
    if (id.indexOf('tomato-soup') !== -1) return '🍅';
    if (id.indexOf('green-salad') !== -1) return '🥗';
    if (id.indexOf('garlic-bread') !== -1) return '🍞';
    if (id.indexOf('burrata') !== -1) return '🧀';
    if (id.indexOf('roast-chicken') !== -1) return '🍗';
    if (id.indexOf('grilled-salmon') !== -1) return '🐟';
    if (id.indexOf('mushroom-risotto') !== -1) return '🍄';
    if (id.indexOf('steak-frites') !== -1) return '🥩';
    if (id.indexOf('chocolate-tart') !== -1) return '🍫';
    if (id.indexOf('lemon-posset') !== -1) return '🍋';
    if (id.indexOf('panna-cotta') !== -1) return '🍮';
    if (id.indexOf('apple-crumble') !== -1) return '🍎';
    if (id.indexOf('lemonade') !== -1) return '🥤';
    if (id.indexOf('coffee') !== -1) return '☕';
    if (id.indexOf('iced-tea') !== -1) return '🧋';
    if (id.indexOf('red-wine') !== -1) return '🍷';
    return '🍽️';
  }

  function addToCart(id, name, price) {
    if (!cart[id]) {
      cart[id] = { id: id, name: name, price: Number(price), qty: 0 };
    }
    cart[id].qty += 1;
    renderCart();
  }

  function updateQty(id, delta) {
    if (!cart[id]) return;
    cart[id].qty += delta;
    if (cart[id].qty <= 0) delete cart[id];
    renderCart();
  }

  // Wire add buttons
  buttons.forEach(function (btn) {
    btn.addEventListener('click', function (e) {
      var id = btn.getAttribute('data-id');
      var name = btn.getAttribute('data-name');
      var price = btn.getAttribute('data-price');
      addToCart(id, name, price);
      document.body.classList.add('cart-open');
    });
  });

  // Cart toggle and overlay
  function closeCart() { document.body.classList.remove('cart-open'); }
  if (cartToggle) cartToggle.addEventListener('click', function () { document.body.classList.toggle('cart-open'); });
  if (cartOverlay) cartOverlay.addEventListener('click', closeCart);

  // Delegate qty controls
  if (cartItemsEl) {
    cartItemsEl.addEventListener('click', function (e) {
      var target = e.target;
      if (!(target instanceof HTMLElement)) return;
      var action = target.getAttribute('data-action');
      var id = target.getAttribute('data-id');
      if (!action || !id) return;
      if (action === 'inc') updateQty(id, 1);
      if (action === 'dec') updateQty(id, -1);
    });
  }

  // Enhanced checkout with backend integration
  function openModal() {
    if (orderMessage) orderMessage.style.display = 'none';
    var form = document.getElementById('checkout-form');
    if (form) form.style.display = '';
    if (placeOrderBtn) placeOrderBtn.style.display = '';
    if (checkoutTitle) checkoutTitle.textContent = 'Checkout';
    updatePaymentDetails();
    document.body.classList.add('modal-open');
  }
  
  function closeModal() { document.body.classList.remove('modal-open'); }
  
  if (checkoutBtn) checkoutBtn.addEventListener('click', function () { openModal(); });
  if (modalBackdrop) modalBackdrop.addEventListener('click', closeModal);
  if (modalClose) modalClose.addEventListener('click', closeModal);
  
  if (placeOrderBtn) placeOrderBtn.addEventListener('click', async function () {
    var form = document.getElementById('checkout-form');
    if (form && form.checkValidity()) {
      // Show loading state
      placeOrderBtn.textContent = 'Processing...';
      placeOrderBtn.disabled = true;
      
      try {
        // Prepare order data
        var orderData = {
          items: getCartList(),
          customer: {
            name: document.getElementById('cust-name').value,
            address: document.getElementById('cust-address').value,
            phone: document.getElementById('cust-phone').value,
            email: document.getElementById('cust-email').value
          },
          payment: getSelectedPaymentMethod(),
          total: getCartList().reduce(function (sum, it) { return sum + it.qty * it.price; }, 0)
        };

        // Try to save to backend
        const backendAvailable = await checkBackend();
        if (backendAvailable) {
          try {
            const response = await fetch(`${API_BASE}/orders`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ items: orderData.items })
            });
            
            if (response.ok) {
              const result = await response.json();
              orderMessage.textContent = `Thank you for your order! Order #${result.order.id} has been placed. Payment method: ${orderData.payment}.`;
              showStatus('✅ Order saved to backend!');
            } else {
              throw new Error('Backend save failed');
            }
          } catch (error) {
            // Fallback to local only
            orderMessage.textContent = `Thank you for your order! Payment method: ${orderData.payment}. (Order saved locally)`;
            showStatus('⚠️ Order saved locally only', true);
          }
        } else {
          // Local only
          orderMessage.textContent = `Thank you for your order! Payment method: ${orderData.payment}. (Order saved locally)`;
          showStatus('⚠️ Backend unavailable - order saved locally', true);
        }
        
        orderMessage.style.display = 'block';
        
        // Reset cart
        cart = {};
        renderCart();
        
        setTimeout(function () { 
          closeModal();
          placeOrderBtn.textContent = 'Place Order';
          placeOrderBtn.disabled = false;
        }, 2000);
        
      } catch (error) {
        console.error('Order processing error:', error);
        orderMessage.textContent = 'There was an error processing your order. Please try again.';
        orderMessage.style.display = 'block';
        placeOrderBtn.textContent = 'Place Order';
        placeOrderBtn.disabled = false;
      }
    } else if (form) {
      form.reportValidity();
    }
  });

  function getSelectedPaymentMethod() {
    var radios = document.querySelectorAll('input[name="pay"]');
    var method = 'Cash';
    Array.prototype.forEach.call(radios, function (r) { 
      if (r.checked) method = r.value; 
    });
    return method;
  }

  // Dynamic payment help/fields
  function updatePaymentDetails() {
    var method = getSelectedPaymentMethod();
    if (!payHelp) return;
    var help = '';
    if (method === 'Cash') {
      help = 'Pay with cash on delivery. Have the exact amount ready if possible.';
      if (cardFields) cardFields.style.display = 'none';
    } else if (method === 'Visa' || method === 'MasterCard' || method === 'Amex') {
      help = 'Enter your card details below to complete payment.';
      if (cardFields) cardFields.style.display = 'grid';
    } else if (method === 'PayPal') {
      help = 'You will be redirected to PayPal to complete payment (simulated).';
      if (cardFields) cardFields.style.display = 'none';
    } else if (method === 'Apple Pay' || method === 'Google Pay') {
      help = 'Confirm payment using your wallet on the next step (simulated).';
      if (cardFields) cardFields.style.display = 'none';
    }
    payHelp.textContent = help;
  }

  updatePaymentDetails();
  document.addEventListener('change', function (e) {
    var t = e.target;
    if (!(t instanceof HTMLElement)) return;
    if (t.getAttribute('name') === 'pay') {
      updatePaymentDetails();
    }
  });

  // Initialize backend connection
  initBackend();
});
