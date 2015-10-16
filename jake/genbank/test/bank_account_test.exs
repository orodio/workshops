defmodule BankAccountTest do
  use ExUnit.Case

  test "Account starts with no moneys" do
    new_account
    |> assert_balance(0)
  end

  test "Can deposit moneys" do
    new_account
    |> deposit(50)
    |> assert_balance(50)
  end

  test "Can Withdraw moneys" do
    new_account
    |> deposit(50)
    |> withdraw(30)
    |> assert_balance(20)
  end

  test "Cant withdraw more moneys then the moneys you have" do
    new_account
    |> deposit(50)
    |> withdraw(80)
    |> assert_balance(50)
  end

  def new_account do
    { :ok, pid } = BankAccount.start_link
    pid
  end

  def deposit pid, amount do
    BankAccount.deposit(pid, amount)
    pid
  end

  def withdraw pid, amount do
    BankAccount.withdraw(pid, amount)
    pid
  end

  def assert_balance pid, amount do
    assert BankAccount.get_balance(pid) == amount
    pid
  end
end
