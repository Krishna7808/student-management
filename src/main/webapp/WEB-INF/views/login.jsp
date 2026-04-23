<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SMS - Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            width: 100%;
            max-width: 400px;
            border-radius: 15px;
            overflow: hidden;
            background: white;
        }
    </style>
</head>
<body>

    <div class="card login-card shadow-lg">
        <div class="card-header text-center py-4 bg-white border-0">
            <h4 class="fw-bold text-primary">Student Management System</h4>
            <p class="text-muted mb-0">Sign in to manage records</p>
        </div>
        
        <div class="card-body p-4">
            
            <c:if test="${param.error == 'true'}">
                <div class="alert alert-danger py-2 text-center" role="alert">
                    Invalid Username or Password
                </div>
            </c:if>

            <c:if test="${param.registered == 'true'}">
                <div class="alert alert-success py-2 text-center" role="alert">
                    Account created! Please login.
                </div>
            </c:if>

            <form action="/login" method="POST">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" placeholder="Enter username" required>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 shadow-sm mb-3">
                    Login
                </button>
            </form>

            <div class="text-center mt-3">
                <p class="small text-muted mb-0">New user?</p>
                <a href="/register" class="text-primary fw-bold text-decoration-none">Create an Account</a>
            </div>
        </div>
        
        <div class="card-footer bg-light text-center py-3 border-0">
            <small class="text-muted">Faculty can edit | Students can view</small>
        </div>
    </div>

</body>
</html>