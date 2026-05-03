// Path: src/main/resources/static/js/portal.js

function portalLookup() {
    const ref   = document.getElementById('portalRef').value.trim();
    const token = document.getElementById('portalToken').value.trim();
    const result = document.getElementById('portalResult');

    result.className = 'portal-result hidden';
    result.innerHTML = '';

    if (!ref || !token) {
        result.className = 'portal-result error';
        result.textContent = 'Please enter both your reference number and access token.';
        return;
    }

    const params = new URLSearchParams();
    params.append('referenceNumber', ref);
    params.append('token', token);

    fetch('/portal/lookup', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: params.toString()
    })
    .then(res => res.json())
    .then(data => {
        if (!data.success) {
            result.className = 'portal-result error';
            result.textContent = data.message || 'Lookup failed. Please check your credentials.';
            return;
        }

        result.className = 'portal-result success';

        if (!data.documents || data.documents.length === 0) {
            result.innerHTML = '<strong>No documents on file.</strong> Please contact the Registrar.';
            return;
        }

        let html = '<strong>Documents for ' + escHtml(ref) + ':</strong><br><br>';
        html += '<table style="width:100%;border-collapse:collapse;font-size:0.82rem;">';
        html += '<thead><tr style="border-bottom:1px solid #a7f3d0;">';
        html += '<th style="text-align:left;padding:4px 8px;">Type</th>';
        html += '<th style="text-align:left;padding:4px 8px;">Tracking #</th>';
        html += '<th style="text-align:left;padding:4px 8px;">Status</th>';
        html += '</tr></thead><tbody>';

        data.documents.forEach(function (doc) {
            html += '<tr style="border-bottom:1px solid #d1fae5;">';
            html += '<td style="padding:5px 8px;">' + escHtml(doc.documentType) + '</td>';
            html += '<td style="padding:5px 8px;font-family:monospace;">' + escHtml(doc.trackingNo) + '</td>';
            html += '<td style="padding:5px 8px;"><strong>' + escHtml(doc.status) + '</strong>';
            if (doc.rejectionReason) {
                html += '<br><small style="color:#065f46;">' + escHtml(doc.rejectionReason) + '</small>';
            }
            html += '</td></tr>';
        });

        html += '</tbody></table>';
        result.innerHTML = html;
    })
    .catch(function () {
        result.className = 'portal-result error';
        result.textContent = 'An error occurred. Please try again later.';
    });
}

function escHtml(str) {
    if (!str) return '';
    return String(str)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}