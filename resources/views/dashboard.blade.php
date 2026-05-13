<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Dashboard</title>
</head>
<body>
    <h1>Dashboard</h1>

    <p>Welcome, {{ auth()->user()->name }}</p>

    <form method="POST" action="/logout">
        @csrf
        @method('DELETE')
        <button type="submit">Logout</button>
    </form>
</body>
</html>
