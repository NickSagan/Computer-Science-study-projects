import os

from cs50 import SQL
from flask import Flask, flash, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True


# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    stocks = db.execute("SELECT * FROM stocks WHERE user_id = :user_id ORDER BY symbol ASC", user_id=session["user_id"])
    user = db.execute("SELECT * FROM users WHERE id = :id", id=session["user_id"])
    grand_total = 0.0

    for i in range(len(stocks)):
        stock = lookup(stocks[i]["symbol"])
        stocks[i]["company"] = stock["name"]
        stocks[i]["cur_price"] = "%.2f"%(stock["price"])
        stocks[i]["cur_total"] = "%.2f"%(float(stock["price"]) * float(stocks[i]["quantity"]))
        stocks[i]["profit"] = "%.2f"%(float(stocks[i]["cur_total"]) - float(stocks[i]["total"]))
        grand_total += stocks[i]["total"]
        stocks[i]["total"] = "%.2f"%(stocks[i]["total"])

    grand_total += float(user[0]["cash"])

    return render_template("index.html", stocks=stocks, cash=usd(user[0]["cash"]), grand_total=usd(grand_total))


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""
    if request.method == "POST":

        # checking input
        if not request.form.get("symbol") or not request.form.get("shares"):
            return render_template("buy.html")

        if int(request.form.get("shares")) < 1:
            return apology("Incorrect stocks quantity", 400)

        symbol = request.form.get("symbol").upper()
        quantity = request.form.get("shares")
        user_id = session["user_id"]

        # lookup for stock
        stock = lookup(symbol)

        # checking if symbol exists
        if not stock:
            return apology("Symbol is not found")

        # calculating total price
        total_price = float(stock["price"]) * float(quantity)

        user = db.execute("SELECT * FROM users WHERE id = :id", id=user_id)
        funds = float(user[0]["cash"])

        # checking if user has enough funds
        if funds < total_price:
            return apology("Not enough funds", 400)

        funds_left = funds - total_price

        # checking if stock is already owned
        stock_db = db.execute("SELECT * FROM stocks WHERE user_id = :user_id AND symbol = :symbol",
                            user_id=user_id, symbol=symbol)

        # updating with a new price if it is owned
        if len(stock_db) == 1:

            new_quantity = int(stock_db[0]["quantity"]) + int(quantity)
            new_total = float(stock_db[0]["total"]) + total_price
            new_pps = "%.2f"%(new_total / float(new_quantity))

            db.execute("UPDATE stocks SET quantity = :quantity, total = :total, pps = :pps WHERE user_id = :user_id AND symbol = :symbol",
                        quantity=new_quantity, total=new_total, pps=new_pps, user_id=user_id, symbol=symbol)

        # or creating a new table in db
        else:

            db.execute("INSERT INTO stocks (user_id, symbol, quantity, total, pps) VALUES (:user_id, :symbol, :quantity, :total, :pps)",
                        user_id=user_id, symbol=symbol, quantity=quantity, total=total_price, pps=stock["price"])

        # updating funds
        db.execute("UPDATE users SET cash = :cash WHERE id = :id", cash=funds_left, id=user_id)

        # saving in history
        db.execute("INSERT INTO history (user_id, action, symbol, quantity, pps) VALUES (:user_id, :action, :symbol, :quantity, :pps)",
                    user_id=user_id, action=1, symbol=symbol, quantity=quantity, pps=stock["price"])

        # render success tmplt
        return render_template("success.html", action="bought", quantity=quantity,
                                name=stock["name"], total=usd(total_price), funds=usd(funds_left))

    # else if it was a GET request
    else:
        return render_template("buy.html")


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""
    # selecting data from db
    stocks = db.execute("SELECT * FROM history WHERE user_id = :user_id ORDER BY user_id DESC", user_id=session["user_id"])

    # getting total price of all transactions
    for i in range(len(stocks)):
        stocks[i]["total"] = "%.2f"%(float(stocks[i]["quantity"]) * float(stocks[i]["pps"]))

    # rendering histrory tmplt
    return render_template("history.html", stocks=stocks)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""
    session.clear()

    if request.method == "POST":

        # Checking username
        if not request.form.get("username"):
            return apology("No username", 400)

        # Checking password
        elif not request.form.get("password"):
            return apology("No password", 400)

        # SELECT username
        user = db.execute("SELECT * FROM users WHERE username = ?", request.form.get("username"))

        # Checking username and password
        if len(user) != 1 or not check_password_hash(user[0]["hash"], request.form.get("password")):
            return apology("Not correct username or password", 400)

        # Remembering session
        session["user_id"] = user[0]["id"]

        # Redirecting to index
        return redirect("/")

    # else if it was GET request
    else:
        return render_template("login.html")


@app.route("/logout")
def logout():
    """Log user out"""
    session.clear()
    # Redirect user to index
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""
    if request.method == "POST":
        # if input is empty
        if not request.form.get("symbol"):
            return apology("Blank ticker symbol", 400)
        # requesting stock
        stock = lookup(request.form.get("symbol"))
        if not stock:
            return apology("Stock is not found", 400)
        return render_template("quoted.html", symbol=stock["symbol"], name=stock["name"], price=stock["price"])
    else:
        return render_template("quote.html")


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "POST":
        # checking username
        if not request.form.get("username"):
            return apology("No username", 400)
        # checking pass
        elif not request.form.get("password") or not request.form.get("confirmation"):
            return apology("No password", 400)
        # checking passwords to be equal
        elif request.form.get("password") != request.form.get("confirmation"):
            return apology("Please, check you passwords", 400)
        # checking if username is unique
        users = db.execute("SELECT * FROM users WHERE username = :username", username=request.form.get("username"))
        if len(users) >= 1:
            return apology("Sorry, your username is not unique", 400)
        # adding new user into database
        username=request.form.get("username")
        hashNew=generate_password_hash(request.form.get("password"))
        db.execute("INSERT INTO users (username, hash) VALUES (?, ?)", username, hashNew)

        # login user automatically and remember session
        user = db.execute("SELECT * FROM users WHERE username = :username", username=request.form.get("username"))
        session["user_id"] = user[0]["id"]
        return redirect("/")
    else:
        return render_template("register.html")

@app.route("/cash", methods=["GET", "POST"])
@login_required
def cash():
    """Add some cash."""
    if request.method == "POST":
        # if input is empty
        if not request.form.get("amount"):
            return apology("Incorrect amount", 400)
        # requesting amount
        amount = request.form.get("amount")
        user_id = session["user_id"]

        # SELECT user from db
        user = db.execute("SELECT * FROM users WHERE id = :id", id=user_id)
        # UPDATE user's funds
        funds = float(user[0]["cash"]) + float(amount)
        db.execute("UPDATE users SET cash = :cash WHERE id = :id", cash=funds, id=user_id)

        return render_template("cashadded.html", quantity=amount, funds=usd(funds))
    else:
        return render_template("cash.html")

@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""
    stocks = db.execute("SELECT * FROM stocks WHERE user_id = :user_id", user_id=session["user_id"])

    if request.method == "POST":

        # checking shares quantity
        if not request.form.get("shares") or int(request.form.get("shares")) < 1:
            return render_template("sell.html", stocks=stocks)

        user_id = session["user_id"]
        symbol = request.form.get("symbol").upper()
        quantity = request.form.get("shares")

        # SELECT stocks db
        stock_db = db.execute("SELECT * FROM stocks WHERE user_id = :user_id AND symbol = :symbol",
                            user_id=user_id, symbol=symbol)
        if stock_db:
            stock_db = stock_db[0]
        else:
            return render_template("sell.html", stocks=stocks)

        # SELECT user from db
        user = db.execute("SELECT * FROM users WHERE id = :id", id=user_id)

        # Checking quantity
        if int(quantity) > stock_db["quantity"]:
            return apology("Incorrect stocks quantity", 400)

        # Check current price for this stock
        stock = lookup(symbol)

        # Getting total price
        total_price = float(stock["price"]) * float(quantity)

        # UPDATE stocks number or delete if it is less then 1
        if int(quantity) == stock_db["quantity"]:
            db.execute("DELETE FROM stocks WHERE user_id = :user_id AND symbol = :symbol", user_id=user_id, symbol=symbol)
        else:
            new_quantity = int(stock_db["quantity"]) - int(quantity)
            new_total = float(new_quantity) * float(stock_db["pps"])
            db.execute("UPDATE stocks SET quantity = :quantity, total = :total WHERE user_id = :user_id AND symbol = :symbol",
                        quantity=new_quantity, total=new_total, user_id=user_id, symbol=symbol)

        # Checking funds
        funds_available = float(user[0]["cash"]) + total_price
        db.execute("UPDATE users SET cash = :cash WHERE id = :id", cash=funds_available, id=user_id)

        # INSERT to histroy
        db.execute("INSERT INTO history (user_id, action, symbol, quantity, pps) VALUES (:user_id, :action, :symbol, :quantity, :pps)",
                    user_id=user_id, action=0, symbol=symbol, quantity=quantity, pps=stock["price"])

        # render success
        return render_template("success.html", action="sold", quantity=quantity,
                                name=stock["name"], total=usd(total_price), funds=usd(funds_available))

    # else if GET
    else:
        return render_template("sell.html", stocks=stocks)

def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)

# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)