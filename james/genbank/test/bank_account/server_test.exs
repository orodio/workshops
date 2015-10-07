defmodule BankAccount.ServerTest do
  use ExUnit.Case
  alias BankAccount.Server, as: Account

  test "Bank Account Starts Empty" do
    new_bank_account
      |> assert_balance(0)
  end

  test "Can deposit moneys into bank account" do
    new_bank_account
      |> deposit(50)
      |> assert_balance(50)
  end

  test "Can withdraw moneys into bank account" do
    new_bank_account
      |> deposit(50)
      |> withdraw(30)
      |> assert_balance(20)
  end

  test "Cannot withdraw moneys from bank account if no moneys" do
    new_bank_account
      |> deposit(20)
      |> withdraw(50)
      |> assert_balance(20)
  end

  defp new_bank_account do
    { :ok, pid } = Account.start_link
    pid
  end

  defp deposit pid, value do
    Account.deposit pid, value
    pid
  end

  defp withdraw pid, value do
    Account.withdraw pid, value
    pid
  end

  defp assert_balance pid, value do
    assert Account.get_balance(pid) === value
    pid
  end
end
