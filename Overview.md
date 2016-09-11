# TDD OOP TBD
_(Or how test driven development and object oriented programming were meant for each other)_

## Overview
In this session, students get first-hand experience following test-driven-development practices with professional tools like RSpec.

## Objectives
Students will be able to:
* Understand and use basic RSpec syntax (`describe`, `it`, `expect`).
* Approach projects by first outlining expectations.
* Utilize the basic building blocks of Ruby's object model including:
  * attribute access methods
  * `initialize`
  * instance methods

## Background
You've been approached by a small bank in a remote island nation that still uses paper to manage their six customer accounts. They don't care about security or durability. They only gave you these requirements:

1. We need to be able to create new bank accounts with opening balances and the name of the client.
1. We should be able to check an account's balance at any time.
1. We need to be able to make deposits and withdrawals to those accounts.
1. We should be able to transfer funds between accounts.
1. We want to have a minimum opening balance. We should be able to change that amount at any time.

Bonus:

1. We heard that bigger banks are making lots of money with overdraft fees. Let's add an overdraft fee whenever customers overdraft their account. We should be able to change that fee for all of our accounts at any time.
1. We want to be able to see a running transaction history.
1. _Super bonus:_ Power goes out quite a bit on our island nation. Bank accounts should write their transaction history to files on the disk as a backup.
1. _Super bonus:_ We should be able to recover a bank account from it's transaction history file.

Let's think about this for a second. It's similar to your REPL games but with more complex functionality.  Can you imagine building this right now? It would probably take hundreds of lines of spaghetti code and hours of headaches accomplish.

OOP and TDD will make this project remarkably simpler to tackle.

## Setup
Create a folder to house this project and cd into the folder:

```sh
mkdir oop_bank
cd oop_bank
```

First off, RSpec will look for a `spec` folder to find your tests.

```sh
# In oop_bank/
mkdir spec
```

Now, let's think about the challenge. It seems to all revolve around one _thing_. That _thing_ is a bank account. It makes sense then, that we will start with a `BankAccount` class to handle the responsibilities of a bank account.

Let's create a file to hold our tests for this class. RSpec will look for our tests inside our `spec` folder in `_spec.rb` files. Create a `spec/bank_account_spec.rb` file. It's convention to name these files the same as the code they're testing. Open the whole `oop_bank` folder in Atom after that.

```sh
# In oob_bank/
touch spec/bank_account_spec.rb
atom .
```

Let's start preparing our tests. Well-written tests **_describe_** your code. They do this by providing **_examples_** of how the code is **_expected_** to behave. Those three words are important.

> RSpec **_describes_** your code with **_examples_** of how your code is **_expected_** to behave.

Enter this in your `bank_account_spec.rb`:

```rb
# In spec/bank_account_spec.rb
describe BankAccount do

end
```

Every RSpec test file begins with that `describe` method. It specifies what bit of code this specific file is **_describing_** (testing). It takes two arguments: the class being tested, and a block. That block is where we put our examples:

```rb
# In spec/bank_account_spec.rb
describe BankAccount do
  it "is created with an opening balance and the name of the client"
  it "can report it's balance"
  it "can make deposits"
  it "can make withdrawals"
  it "can transfer funds to another bank account"
  it "has a minimum opening balance"
  it "allows the user to change the minimum balance"
end
```
RSpec uses the `it` method to create **_examples_**. Right now, they're just taking one argument, a string we use to name that feature or example.   Soon, we'll add some more code to fill them out, but it's important to start with this "todo list" so we keep our goals in mind.  

At this point, I like to run RSpec to make sure I've set everything up ok:

```sh
# In terminal (oop_bank/)
rspec
```

Read that error that came out. Are you surprised by it? `uninitialized constant BankAccount`. Well duh. RSpec isn't magic. That spec file is just methods and strings and a block. There is no `BankAccount` class, and yet there we are trying to pass it in as an argument to `describe`.

Let's create that `BankAccount` class.

```sh
# In Terminal (oop_bank/)
touch bank_account.rb
```

In that file, let's define the `BankAccount` class.

```rb
# In oop_bank/bank_account.rb
class BankAccount
end
```

Run `rspec` again. Same error. RSpec doesn't load all our files for us. It just looks in our `spec` folder for `_spec.rb` files. Ruby still never saw the 'BankAccount' class. We have to `require` it.

```rb
# In spec/bank_account_spec.rb
require './bank_account'

describe BankAccount do
  #...
```

Now try `rspec`. We see that we get `7 examples, 0 failures, 7 pending`. Perfect. Everything is in place, and every example is showing as not yet implemented, because they're aren't.

> **Vain detour:** Colors make things easier to read (and seeing real red and green is more fun.) Run `rspec -c` from now on to see the world in Technicolor.

## Walkthrough
That's all the setup you need in order to start a project with RSpec. Let's get to work meeting our client's requirements.

### 1) Creating Bank Accounts
The first feature that we've pulled out from the client's request let's us know that a `BankAccount` "is created with an opening balance and the name of the client". I'll teach by example how you prepare an RSpec example.

First off, you pass a block to the `it` method:

```rb
# In spec/
it "is created with an opening balance and the name of the client" do

end
```

Now, we _write the code we wish we had_:

```rb
# In spec/
it "is created with an opening balance and the name of the client" do
  account = BankAccount.new(500, "Sarah")
end
```

And finally, we set our **_expectation_**:

```rb
# In spec/
it "is created with an opening balance and the name of the client" do
  account = BankAccount.new(500, "Sarah")
  expect(account).to be_a(BankAccount)
end
```

What is this sorcery?! It's not magic. A method named `expect` takes an argument. We call `to` on whatever it returns and pass a [**_matcher_**](http://lmgtfy.com/?q=rspec+matcher) to that method. There are many matchers. We will use a few of them, and that's all you really need. In this case, we want to verify that `account` _is a_ `BankAccount`. Basically, did it work and not blow up?

Run the test. Let's see what RSpec says.

It reports an error: `wrong number of arguments (2 for 0)`. Why did that happen? Take a few moments to make this test pass (by working on your `BankAccount` class) and we'll continue.

### 2) Reading a Bank Account's balance
The second feature requested of us is to make the Bank Account capable of reporting it's balance. Once again, let's write the code we wish we had and set our expectation.

Create an account, just like before, and then set the expectation that it's `balance` reflects the correct value. (A `balance` method would helpful here.)

```rb
# In bank_account_spec.rb
it "can report it's balance" do
  account = BankAccount.new(500, "Sarah")
  expect(account.balance).to eq(500)
end
```

We're using a different matcher here. `be_a` verified that the subject was a certain class, `eq` does exactly what it sounds like, it checks that they're equal, like `==` would do.

Run the tests. What does RSpec say? Take a few moments to make this test pass.

### 3) Making deposits

Finally, our next task is to make deposits. Once again, write the code we wish we had.

1) Create an account
2) make a deposit to that account (let's try calling a `deposit` method)
3) Set the expectation that the balance changed to reflect your deposit.

<details>
  <summary>View the test:</summary>

```rb
it "can make deposits" do
  account = BankAccount.new(500, "Sarah")
  account.deposit(500)
  expect(account.balance).to eq(1000)
end
```
</details>
<br>

When we run our test, RSpec complains about an undefined method `deposit`. We'll need to define that deposit method, and it will also need to affect the account's balance in order to meet our expectation.

### 4) Making withdrawals

By this point, hopefully you're starting to get the hang of a workflow. You shouldn't have that terrible "where do I begin?!" feeling anymore, because the errors tell you what to do. _By the way, read the errors!!_

To recap: We broke the problem into specific "features" that we could implement and outlined them using RSpec. One at a time, we wrote **_examples_** of how we wanted our code to work. We'd then use the errors to guide us to our goal, earning a greenlight when our code meets our **_expectations_**.

This method is very similar to deposit.

<details>
  <summary>View the test:</summary>

```rb
it "can make withdrawals" do
  account = BankAccount.new(500, "Sarah")
  account.withdraw(200)
  expect(account.balance).to eq(300)
end
```
</details>
Once again: red, green, refactor.

### 5) Transferring funds
This feature is interesting, and it gives us our first look at how two objects can interact with each other by "sending messages" to each other. To prepare our example of how we want this method to function, we need to
1) Create two bank accounts
2) Call a `transfer` method on one `BankAccount`, passing it two arguments: an `amount` and the other `BankAccount`. (With these two arguments, it will know how much to move and which `BankAccount` to move it to.
3) Finally, we'd set expectations that both `BankAccount` balances reflect the transfer.

<details>
  <summary>View the test:</summary>

```rb
it "can transfer funds to another bank account" do
  account1 = BankAccount.new(500, "Sarah")
  account2 = BankAccount.new(500, "John")
  account1.transfer(200, account2)
  expect(account1.balance).to eq(300)
  expect(account2.balance).to eq(700)
end
```
</details>

### 6) Minimum opening balance
Here is another interesting one. We need our `BankAccount` to refuse to instantiate if we try to create one with too small of a balance. Before we worry about letting the Bank change their minimum balance, let's first just set that default minimum balance to `200`.

One of RSpec's `matchers` is the [`raise_error` matcher](https://www.relishapp.com/rspec/rspec-expectations/v/3-4/docs/built-in-matchers/raise-error-matcher). (notice also on the left all the other matchers it comes with).

We pass it a block of code, and can then expect it to raise an error. For good practice, we should always expect a specific error to be raised. Let's take a look at the list of built-in Ruby errors for us to raise. For this example, let's expect that creating a `BankAccount` with less than 200 opening balance will raise an argument error.

<details>
  <summary>View the test:</summary>

```rb
it "throws an error if minimum opening balance of 200 is not met" do
  expect { BankAccount.new(100, "Sarah") }.to raise_error(ArgumentError)
end
```
</details>

### 7) Changing the minimum balance
We were also asked to allow our client to change the minimum balance at any time. It might be tempted to say "it's right there in the code, just change it!", but you can _never_ ask your user to change your code. Even if you are writing code for another developer, you should give them methods that let them configure it rather than make them change your code themselves.

Let's talk through this one. If we need to change the way all `BankAccounts` behave, that change needs to happen at the class level. We should use a **class variable** to store the `minimum_balance` and provide a **class method** to change it.

For our example:

1) Call a class method `minimum_balance=` to make the minimum balance higher.
2) Try to create a `BankAccount` with more than 200 but still under our new minimum balance, and expect that to raise an error.
3) And just to be sure, try to create a `BankAccount` with out new minimum balance and expect that `to_not` raise an error.

<details>
  <summary>View the test:</summary>

```rb
it "allows user to configure minimum balance" do
  BankAccount.minimum_balance = 500
  expect { BankAccount.new(300, "Sarah") }.to raise_error(ArgumentError)
  expect { BankAccount.new(500, "Sarah") }.to_not raise_error(ArgumentError)
end
```
</details>
