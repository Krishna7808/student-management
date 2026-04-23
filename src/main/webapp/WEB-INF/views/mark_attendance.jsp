<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mark Attendance | SMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .page-header { background: #1a2a3a; color: white; padding: 18px 30px; border-radius: 12px; margin-bottom: 28px; }
        .att-table th { background-color: #1a2a3a; color: white; text-align: center; vertical-align: middle; }
        .att-table td { vertical-align: middle; text-align: center; }
        .att-table .subject-cell { text-align: left; font-weight: 600; background-color: #f8f9fa; }
        .type-badge-th { background-color: #0d6efd; color: white; padding: 3px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 700; }
        .type-badge-pr { background-color: #198754; color: white; padding: 3px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 700; }
        .pct-cell { font-weight: 700; font-size: 1rem; }
        .pct-low { color: #dc3545; }
        .pct-ok { color: #fd7e14; }
        .pct-good { color: #198754; }
        .summary-row td { font-weight: 700; background-color: #e9ecef; }
        input[type=number] { text-align: center; }
    </style>
</head>
<body>
<div class="container py-4">

    <div class="page-header d-flex justify-content-between align-items-center">
        <div>
            <h4 class="mb-0">📋 Mark Subject-wise Attendance</h4>
            <small class="opacity-75">Student ID: #${studentId} &nbsp;|&nbsp; Faculty: ${sessionScope.userName}</small>
        </div>
        <a href="/" class="btn btn-outline-light btn-sm">← Back to Dashboard</a>
    </div>

    <div class="card shadow-sm border-0 rounded-3">
        <div class="card-body p-4">
            <form action="/saveAttendance" method="POST" id="attForm">
                <input type="hidden" name="studentId" value="${studentId}" />

                <table class="table table-bordered att-table">
                    <thead>
                        <tr>
                            <th style="width:5%">Sr.</th>
                            <th style="width:30%" class="text-start ps-3">Subject</th>
                            <th style="width:10%">Type</th>
                            <th style="width:18%">Present Periods</th>
                            <th style="width:18%">Total Periods</th>
                            <th style="width:19%">Percentage (%)</th>
                        </tr>
                    </thead>
                    <tbody id="attBody">
                        <c:set var="sr" value="1" />
                        <c:forEach var="subject" items="${subjects}" varStatus="loop">
                            <%-- Theory Row --%>
                            <tr>
                                <td rowspan="2" class="subject-cell text-center fw-bold">${loop.index + 1}</td>
                                <td rowspan="2" class="subject-cell ps-3">${subject}</td>
                                <td><span class="type-badge-th">TH</span>
                                    <input type="hidden" name="subject" value="${subject}" />
                                    <input type="hidden" name="type" value="TH" />
                                </td>
                                <td>
                                    <input type="number" class="form-control form-control-sm present-input"
                                           name="presentPeriods" min="0" value="0"
                                           data-row="th-${loop.index}" onchange="calcPct(this)" required />
                                </td>
                                <td>
                                    <input type="number" class="form-control form-control-sm total-input"
                                           name="totalPeriods" min="0" value="0"
                                           data-row="th-${loop.index}" onchange="calcPct(this)" required />
                                </td>
                                <td class="pct-cell">
                                    <span id="pct-th-${loop.index}" class="pct-good">0.00%</span>
                                </td>
                            </tr>
                            <%-- Practical Row --%>
                            <tr>
                                <td><span class="type-badge-pr">PR</span>
                                    <input type="hidden" name="subject" value="${subject}" />
                                    <input type="hidden" name="type" value="PR" />
                                </td>
                                <td>
                                    <input type="number" class="form-control form-control-sm present-input"
                                           name="presentPeriods" min="0" value="0"
                                           data-row="pr-${loop.index}" onchange="calcPct(this)" required />
                                </td>
                                <td>
                                    <input type="number" class="form-control form-control-sm total-input"
                                           name="totalPeriods" min="0" value="0"
                                           data-row="pr-${loop.index}" onchange="calcPct(this)" required />
                                </td>
                                <td class="pct-cell">
                                    <span id="pct-pr-${loop.index}" class="pct-good">0.00%</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                    <tfoot>
                        <tr class="summary-row table-secondary">
                            <td colspan="3" class="text-end pe-3">THEORY TOTAL</td>
                            <td id="th-total-present">0</td>
                            <td id="th-total-total">0</td>
                            <td id="th-total-pct" class="pct-cell pct-good">0.00%</td>
                        </tr>
                        <tr class="summary-row table-success">
                            <td colspan="3" class="text-end pe-3">PRACTICAL TOTAL</td>
                            <td id="pr-total-present">0</td>
                            <td id="pr-total-total">0</td>
                            <td id="pr-total-pct" class="pct-cell pct-good">0.00%</td>
                        </tr>
                        <tr class="summary-row table-info">
                            <td colspan="3" class="text-end pe-3">OVERALL TOTAL</td>
                            <td id="all-total-present">0</td>
                            <td id="all-total-total">0</td>
                            <td id="all-total-pct" class="pct-cell pct-good">0.00%</td>
                        </tr>
                    </tfoot>
                </table>

                <div class="d-flex justify-content-end gap-2 mt-3">
                    <a href="/" class="btn btn-secondary px-4">Cancel</a>
                    <button type="submit" class="btn btn-success px-5 fw-bold">Save Attendance</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function getPctClass(pct) {
        if (pct < 75) return 'pct-low';
        if (pct < 85) return 'pct-ok';
        return 'pct-good';
    }

    function calcPct(el) {
        const row = el.dataset.row;
        const tr = el.closest('tr');
        const present = parseInt(tr.querySelector('.present-input').value) || 0;
        const total = parseInt(tr.querySelector('.total-input').value) || 0;
        const pct = total > 0 ? ((present / total) * 100).toFixed(2) : '0.00';
        const span = document.getElementById('pct-' + row);
        span.textContent = pct + '%';
        span.className = getPctClass(parseFloat(pct));
        updateTotals();
    }

    function updateTotals() {
        const rows = document.querySelectorAll('#attBody tr');
        let thP = 0, thT = 0, prP = 0, prT = 0;

        rows.forEach(tr => {
            const hiddenType = tr.querySelector('input[name="type"]');
            if (!hiddenType) return;
            const present = parseInt(tr.querySelector('.present-input').value) || 0;
            const total   = parseInt(tr.querySelector('.total-input').value)   || 0;
            if (hiddenType.value === 'TH') { thP += present; thT += total; }
            else                           { prP += present; prT += total;  }
        });

        const thPct  = thT > 0 ? ((thP / thT) * 100).toFixed(2) : '0.00';
        const prPct  = prT > 0 ? ((prP / prT) * 100).toFixed(2) : '0.00';
        const allP   = thP + prP, allT = thT + prT;
        const allPct = allT > 0 ? ((allP / allT) * 100).toFixed(2) : '0.00';

        document.getElementById('th-total-present').textContent = thP;
        document.getElementById('th-total-total').textContent   = thT;
        document.getElementById('th-total-pct').textContent     = thPct + '%';
        document.getElementById('th-total-pct').className       = 'pct-cell ' + getPctClass(parseFloat(thPct));

        document.getElementById('pr-total-present').textContent = prP;
        document.getElementById('pr-total-total').textContent   = prT;
        document.getElementById('pr-total-pct').textContent     = prPct + '%';
        document.getElementById('pr-total-pct').className       = 'pct-cell ' + getPctClass(parseFloat(prPct));

        document.getElementById('all-total-present').textContent = allP;
        document.getElementById('all-total-total').textContent   = allT;
        document.getElementById('all-total-pct').textContent     = allPct + '%';
        document.getElementById('all-total-pct').className       = 'pct-cell ' + getPctClass(parseFloat(allPct));
    }
</script>
</body>
</html>
