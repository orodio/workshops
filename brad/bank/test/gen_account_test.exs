defmodule GenAccountTest do
  use ExUnit.Case

  test "Bank account starts out empty" do
    new_account
    |> assert_balance(0)
  end

  test "can deposit" do
    new_account
    |> GenAccount.deposit(50)
    |> assert_balance(50)
  end

  test "can withdraw" do
    new_account([ deposit: 50, withdraw: 20, deposit: 20 ])
    |> GenAccount.withdraw(30)
    |> assert_balance(20)
  end

  test "no money no withdraw" do
    new_account([ deposit: 30 ])
    |> GenAccount.withdraw(50)
    |> assert_balance(30)
  end

  ### helpers

  def new_account, do: new_account []
  def new_account state do
    { :ok, pid } = GenAccount.start_link state
    pid
  end

  def assert_balance pid, amount do
    assert GenAccount.get_balance(pid) == amount
  end
end
