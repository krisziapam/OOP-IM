// Path: src/main/resources/static/js/background.js

// Particle canvas background — PUP maroon & gold theme
(function () {
    const canvas  = document.getElementById('bgCanvas');
    const ctx     = canvas.getContext('2d');
    let particles = [];
    let animId;

    function resize() {
        canvas.width  = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    function randomBetween(a, b) {
        return a + Math.random() * (b - a);
    }

    function createParticle() {
        return {
            x:       randomBetween(0, canvas.width),
            y:       randomBetween(0, canvas.height),
            r:       randomBetween(1.2, 3.5),
            dx:      randomBetween(-0.35, 0.35),
            dy:      randomBetween(-0.5, -0.15),
            opacity: randomBetween(0.15, 0.5),
            color:   Math.random() > 0.6 ? '#E8B84B' : '#ffffff'
        };
    }

    function initParticles() {
        particles = [];
        const count = Math.floor((canvas.width * canvas.height) / 9000);
        for (let i = 0; i < count; i++) {
            particles.push(createParticle());
        }
    }

    function draw() {
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        particles.forEach((p, i) => {
            ctx.beginPath();
            ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
            ctx.fillStyle = p.color;
            ctx.globalAlpha = p.opacity;
            ctx.fill();
            ctx.globalAlpha = 1;

            // Draw connecting lines to nearby particles
            for (let j = i + 1; j < particles.length; j++) {
                const q = particles[j];
                const dist = Math.hypot(p.x - q.x, p.y - q.y);
                if (dist < 110) {
                    ctx.beginPath();
                    ctx.moveTo(p.x, p.y);
                    ctx.lineTo(q.x, q.y);
                    ctx.strokeStyle = 'rgba(232, 184, 75, ' + (0.06 * (1 - dist / 110)) + ')';
                    ctx.lineWidth = 0.6;
                    ctx.stroke();
                }
            }

            // Move
            p.x += p.dx;
            p.y += p.dy;

            // Wrap around edges
            if (p.y < -5)             p.y = canvas.height + 5;
            if (p.x < -5)             p.x = canvas.width + 5;
            if (p.x > canvas.width + 5)  p.x = -5;
        });

        animId = requestAnimationFrame(draw);
    }

    window.addEventListener('resize', () => {
        resize();
        initParticles();
    });

    resize();
    initParticles();
    draw();
})();