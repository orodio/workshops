defmodule BankAccountTest do
  use ExUnit.Case

  test "BankAccounts start with a valance of 0" do
    spawn(BankAccount, :start, [])
    |> send_message({:check_balance, self})

    assert_receive { :balance, 0 }
  end

  test "BankAccounts can have money deposited in them" do
    spawn(BankAccount, :start, [])
    |> send_message({:deposit, 20})
    |> send_message({:check_balance, self})

    assert_receive { :balance, 20 }
  end

  test "BankAccounts can have money withdrawn from them" do
    spawn(BankAccount, :start, [])
    |> send_message({:deposit, 20})
    |> send_message({:withdraw, 10})
    |> send_message({:check_balance, self})

    assert_receive { :balance, 10 }
  end

  defp send_message pid, message do
    Process.send pid, message, []
    pid
  end
end
