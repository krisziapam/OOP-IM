// Path: src/main/resources/static/js/dashboard.js

let activeRequirementId = null;
let activeApplicationId = null;

// ---- Modal helpers ----
function openModal(id) {
    document.getElementById(id).classList.remove('hidden');
}

function closeModal(id) {
    document.getElementById(id).classList.add('hidden');
}

// Close modal on backdrop click
document.querySelectorAll('.modal').forEach(function (modal) {
    modal.addEventListener('click', function (e) {
        if (e.target === modal) {
            modal.classList.add('hidden');
        }
    });
});

// ---- File input preview ----
const docFileInput = document.getElementById('docFile');
if (docFileInput) {
    docFileInput.addEventListener('change', function () {
        const preview = document.getElementById('uploadFileName');
        if (this.files.length > 0) {
            preview.textContent = 'Selected: ' + this.files[0].name;
        } else {
            preview.textContent = '';
        }
    });
}

// ---- Open upload modal ----
function openUploadModal(applicationId) {
    activeApplicationId = applicationId;
    loadDocumentTypes();
    openModal('uploadModal');
}

function loadDocumentTypes() {
    const select = document.getElementById('docTypeSelect');
    if (!select) return;

    fetch('/api/requirements/types')
        .then(function (res) { return res.json(); })
        .then(function (types) {
            select.innerHTML = '<option value="">Select document type...</option>';
            types.forEach(function (t) {
                const opt = document.createElement('option');
                opt.value = t.requirementTypeId;
                opt.textContent = t.requirementTypeName;
                select.appendChild(opt);
            });
        })
        .catch(function () {
            select.innerHTML = '<option value="">Failed to load types</option>';
        });
}

function submitUpload() {
    const typeId = document.getElementById('docTypeSelect').value;
    const file   = document.getElementById('docFile').files[0];

    if (!typeId) { alert('Please select a document type.'); return; }
    if (!file)   { alert('Please select a file to upload.'); return; }

    const formData = new FormData();
    formData.append('applicationId', activeApplicationId);
    formData.append('typeId', typeId);
    formData.append('file', file);

    fetch('/api/requirements/upload', {
        method: 'POST',
        body: formData
    })
    .then(function (res) { return res.json(); })
    .then(function (data) {
        if (data.success) {
            closeModal('uploadModal');
            showToast('Document uploaded. Tracking No: ' + data.trackingNo, 'success');
            setTimeout(function () { location.reload(); }, 1500);
        } else {
            showToast(data.message || 'Upload failed.', 'error');
        }
    })
    .catch(function () {
        showToast('Network error. Please try again.', 'error');
    });
}

// ---- Verify document ----
function verifyDocument(requirementId) {
    if (!confirm('Mark this document as Verified/Received?')) return;

    fetch('/api/requirements/' + requirementId + '/verify', { method: 'POST' })
        .then(function (res) { return res.json(); })
        .then(function (data) {
            if (data.success) {
                showToast('Document verified.', 'success');
                setTimeout(function () { location.reload(); }, 1200);
            } else {
                showToast(data.message || 'Action failed.', 'error');
            }
        });
}

// ---- Open reject modal ----
function openRejectModal(requirementId) {
    activeRequirementId = requirementId;

    fetch('/api/requirements/rejection-reasons')
        .then(function (res) { return res.json(); })
        .then(function (reasons) {
            const select = document.getElementById('rejectionReasonSelect');
            select.innerHTML = '<option value="">Select a reason...</option>';
            reasons.forEach(function (r) {
                const opt = document.createElement('option');
                opt.value = r.rejectionReasonId;
                opt.textContent = r.rejectionReasonName;
                select.appendChild(opt);
            });
        });

    openModal('rejectModal');
}

function submitReject() {
    const reasonId = document.getElementById('rejectionReasonSelect').value;
    if (!reasonId) { alert('Please select a rejection reason.'); return; }

    const params = new URLSearchParams();
    params.append('reasonId', reasonId);

    fetch('/api/requirements/' + activeRequirementId + '/reject?' + params.toString(), {
        method: 'POST'
    })
    .then(function (res) { return res.json(); })
    .then(function (data) {
        if (data.success) {
            closeModal('rejectModal');
            showToast('Document rejected. Applicant notified.', 'success');
            setTimeout(function () { location.reload(); }, 1200);
        } else {
            showToast(data.message || 'Action failed.', 'error');
        }
    });
}

// ---- Toast notification ----
function showToast(message, type) {
    let toast = document.getElementById('pdtsToast');
    if (!toast) {
        toast = document.createElement('div');
        toast.id = 'pdtsToast';
        toast.style.cssText = [
            'position:fixed', 'bottom:28px', 'right:28px', 'z-index:9999',
            'padding:12px 22px', 'border-radius:8px', 'font-size:0.875rem',
            'font-weight:600', 'box-shadow:0 4px 16px rgba(0,0,0,0.15)',
            'transition:opacity 0.4s', 'max-width:340px'
        ].join(';');
        document.body.appendChild(toast);
    }

    toast.style.background = type === 'success' ? '#065f46' : '#991b1b';
    toast.style.color = '#fff';
    toast.textContent = message;
    toast.style.opacity = '1';

    clearTimeout(toast._timer);
    toast._timer = setTimeout(function () {
        toast.style.opacity = '0';
    }, 3500);
}