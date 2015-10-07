defmodule BankAccount.Server do
  use GenServer

  ### Public API

  def start_link,          do: start_link []
  def start_link(actions), do: GenServer.start_link BankAccount.Server, actions

  def get_balance(pid), do: GenServer.call pid, :check_balance

  def deposit(pid, value),  do: GenServer.cast pid, { :deposit,  value }
  def withdraw(pid, value), do: GenServer.cast pid, { :withdraw, value }

  ### GenServer

  def handle_call :check_balance, _from, actions do
    { :reply, calc_balance(actions), actions }
  end

  def handle_cast action = { :deposit, _value }, actions do
    { :noreply, [action | actions] }
  end

  def handle_cast action = { :withdraw, value }, actions do
    if valid_withdraw(value, actions), do: actions = [action | actions]
    { :noreply, actions }
  end

  defp valid_withdraw(value, actions), do: calc_balance(actions) >= value

  defp calc_balance(actions), do: Enum.reduce actions, 0, &balance_reducer/2

  defp balance_reducer({ :deposit,  value }, acc), do: acc + value
  defp balance_reducer({ :withdraw, value }, acc), do: acc - value
  defp balance_reducer(_action, acc),              do: acc
end
