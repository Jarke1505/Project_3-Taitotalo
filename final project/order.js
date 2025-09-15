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
  var payButton = document.getElementById('pay-button');
  var orderMessage = document.getElementById('order-message');
  var checkoutTitle = document.getElementById('checkout-title');
  var payHelp = document.getElementById('pay-help');
  var cardFields = document.getElementById('card-fields');
  
  console.log('Button elements found:');
  console.log('- Pay button:', payButton);
  console.log('- Checkout title:', checkoutTitle);

  var cart = {};

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

  // Checkout
  function openModal() {
    if (orderMessage) orderMessage.style.display = 'none';
    var form = document.getElementById('checkout-form');
    if (form) form.style.display = '';
    if (checkoutTitle) checkoutTitle.textContent = 'Checkout';
    
    // Remove any existing payment summary
    var existingSummary = document.getElementById('payment-summary');
    if (existingSummary) existingSummary.remove();
    
    updatePaymentDetails();
    document.body.classList.add('modal-open');
  }
  function closeModal() { document.body.classList.remove('modal-open'); }
  if (checkoutBtn) checkoutBtn.addEventListener('click', function () { openModal(); });
  if (modalBackdrop) modalBackdrop.addEventListener('click', closeModal);
  if (modalClose) modalClose.addEventListener('click', closeModal);

  // Single Pay Button (processes payment immediately)
  if (payButton) {
    payButton.addEventListener('click', function () {
      console.log('Pay button clicked');
      var form = document.getElementById('checkout-form');
      if (form && form.checkValidity()) {
        console.log('Form is valid, processing payment');
        
        // Prepare order data
        var orderData = {
          customer: {
            name: document.getElementById('cust-name').value,
            address: document.getElementById('cust-address').value,
            phone: document.getElementById('cust-phone').value,
            email: document.getElementById('cust-email').value
          },
          payment: 'Online Payment',
          items: getCartList(),
          total: getCartList().reduce(function (sum, it) { return sum + it.qty * it.price; }, 0),
          timestamp: new Date().toISOString()
        };
        
        console.log('Order data prepared:', orderData);
        
        // Disable button during processing
        payButton.disabled = true;
        payButton.textContent = 'Processing Payment...';
        payButton.style.background = '#6b7280';
        
        // Show order summary
        var paymentSummary = document.createElement('div');
        paymentSummary.id = 'payment-summary';
        paymentSummary.style.cssText = 'background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 0.5rem; padding: 1rem; margin-top: 1rem;';
        paymentSummary.innerHTML = '<h3 style="margin: 0 0 0.75rem 0; color: #b45309; font-size: 1.1em;">Processing Order</h3>' +
          '<p style="margin: 0.25rem 0; display: flex; justify-content: space-between;"><strong>Customer:</strong> ' + orderData.customer.name + '</p>' +
          '<p style="margin: 0.25rem 0; display: flex; justify-content: space-between;"><strong>Total:</strong> ' + formatEuro(orderData.total) + '</p>' +
          '<p style="margin: 0.25rem 0; display: flex; justify-content: space-between;"><strong>Items:</strong> ' + orderData.items.length + ' items</p>';
        document.querySelector('.modal-body').appendChild(paymentSummary);
        
        // Simulate payment processing delay
        setTimeout(function() {
          console.log('Sending order to backend:', orderData);
          
          // Send order to backend
          fetch('/api/orders', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json'
            },
            body: JSON.stringify(orderData)
          })
          .then(function(response) {
            console.log('Response received:', response.status, response.statusText);
            if (response.ok) {
              return response.json();
            }
            throw new Error('Failed to place order: ' + response.status + ' ' + response.statusText);
          })
          .then(function(data) {
            console.log('Order sent successfully:', data);
            orderMessage.textContent = 'Payment successful! Order #' + (data.orderId || '123') + ' has been placed and paid. Total: ' + formatEuro(orderData.total);
            orderMessage.style.display = 'block';
            orderMessage.style.color = '#28a745';
            orderMessage.style.background = '#d4edda';
            orderMessage.style.padding = '15px';
            orderMessage.style.borderRadius = '5px';
            orderMessage.style.border = '1px solid #c3e6cb';
            
            // Reset everything after successful payment
            cart = {};
            renderCart();
            
            // Reset UI
            payButton.disabled = false;
            payButton.textContent = 'Pay Now';
            payButton.style.background = '#16a34a';
            
            // Remove payment summary
            var paymentSummary = document.getElementById('payment-summary');
            if (paymentSummary) paymentSummary.remove();
            
            // Clear form
            form.reset();
            
            setTimeout(function () { 
              closeModal();
              orderMessage.style.display = 'none';
            }, 4000);
          })
          .catch(function(error) {
            console.error('Error placing order:', error);
            orderMessage.textContent = 'Payment failed: ' + error.message + '. Please try again.';
            orderMessage.style.display = 'block';
            orderMessage.style.color = '#721c24';
            orderMessage.style.background = '#f8d7da';
            orderMessage.style.padding = '15px';
            orderMessage.style.borderRadius = '5px';
            orderMessage.style.border = '1px solid #f5c6cb';
            
            // Re-enable button
            payButton.disabled = false;
            payButton.textContent = 'Pay Now';
            payButton.style.background = '#16a34a';
            
            setTimeout(function () { 
              orderMessage.style.display = 'none';
            }, 5000);
          });
        }, 2000); // 2 second payment processing simulation
        
      } else if (form) {
        console.log('Form is invalid');
        form.reportValidity();
      }
    });
  }

  // Simple payment help
  function updatePaymentDetails() {
    if (payHelp) {
      payHelp.textContent = 'Click "Pay Now" to complete your order. Payment will be processed securely.';
    }
  }

  updatePaymentDetails();
});


