defmodule BankAccount do
  use GenServer

  ### Public API

  def start_link,          do: start_link []
  def start_link(actions), do: GenServer.start_link BankAccount, actions

  def get_balance(pid), do: GenServer.call(pid, :check_balance)

  def deposit(pid, amount), do: GenServer.cast(pid, { :deposit, amount })

  def withdraw(pid, amount), do: GenServer.cast(pid, { :withdraw, amount })

  ### GenServer

  def handle_call(:check_balance, _from, actions) do
    { :reply, calc_balance(actions), actions }
  end

  def handle_cast(action = { :deposit, amount }, actions) do
    { :noreply, [action | actions] }
  end

  def handle_cast(action = { :withdraw, amount }, actions) do
    if valid_withdraw(amount, actions), do: actions = [action | actions]
    { :noreply, actions }
  end

  ### Helpers

  defp valid_withdraw(amount, actions), do: calc_balance(actions) >= amount

  defp calc_balance actions do
    Enum.reduce actions, 0, &balance_reducer/2
  end

  defp balance_reducer({:deposit, amount}, acc), do: acc + amount
  defp balance_reducer({:withdraw, amount}, acc), do: acc - amount
  defp balance_reducer({:transfer, _to_pid, amount}, acc), do: acc - amount
  defp balance_reducer(_action, acc),            do: acc
end
