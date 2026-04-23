<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SMS - Create Account</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-card {
            width: 100%;
            max-width: 450px;
            border-radius: 15px;
            background: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body>

    <div class="card register-card p-4">
        <div class="text-center mb-4">
            <h3 class="fw-bold text-primary">Create Account</h3>
            <p class="text-muted">Join the Student Management System</p>
        </div>

        <c:if test="${not empty error}">
            <div class="alert alert-danger py-2 text-center small">
                ${error}
            </div>
        </c:if>

        <form:form action="/register" modelAttribute="user" method="POST">
            
            <div class="mb-3">
                <label class="form-label">Username</label>
                <form:input path="username" class="form-control" placeholder="Choose a username" required="true" />
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <form:password path="password" class="form-control" placeholder="Create a password" required="true" />
            </div>

            <div class="mb-3">
                <label class="form-label">Select Your Role</label>
                <form:select path="role" id="roleSelect" class="form-select" onchange="toggleSecretField()" required="true">
                    <form:option value="STUDENT">Student (View Only)</form:option>
                    <form:option value="FACULTY">Faculty (Full Access)</form:option>
                </form:select>
            </div>

            <div id="secretField" class="mb-4" style="display:none;">
                <label class="form-label text-danger fw-bold">Faculty Authorization Code</label>
                <form:password path="secretCode" id="secretInput" class="form-control border-danger" placeholder="Enter Admin Code" />
                <div class="form-text text-muted small">Only staff can register as Faculty.</div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 mb-3 shadow-sm">
                Sign Up
            </button>

            <div class="text-center">
                <span class="text-muted small">Already have an account?</span>
                <a href="/login" class="text-primary fw-bold text-decoration-none small">Login Here</a>
            </div>
        </form:form>
    </div>

    <script>
        function toggleSecretField() {
            var role = document.getElementById("roleSelect").value;
            var secretDiv = document.getElementById("secretField");
            var secretInput = document.getElementById("secretInput");

            if (role === "FACULTY") {
                secretDiv.style.display = "block";
                secretInput.setAttribute("required", "true");
            } else {
                secretDiv.style.display = "none";
                secretInput.removeAttribute("required");
                secretInput.value = ""; // Clear input if they switch back to Student
            }
        }
    </script>

</body>
</html>