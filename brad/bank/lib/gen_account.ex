defmodule GenAccount do
  use GenServer

  ### Public
  def start_link, do: start_link []
  def start_link(state), do: GenServer.start_link GenAccount, state

  def get_balance(pid), do: GenServer.call pid, :check_balance

  def withdraw pid, amount do
    GenServer.cast pid, {:withdraw, amount}
    pid
  end

  def deposit pid, amount do
    GenServer.cast pid, {:deposit, amount}
    pid
  end

  ### GenServer

  def handle_call(:check_balance, _from, state) do
    { :reply, calc_balance(state), state }
  end

  def handle_cast(event = { :withdraw, amount } , state) do
    if amount > calc_balance(state) do
      { :noreply, [ {:bad_withdraw, amount, "not enough moneys"} | state ] }
    else
      { :noreply, [event | state] }
    end
  end

  def handle_cast(event = { :deposit, _amount } , state) do
    { :noreply, [event | state] }
  end

  ### Helpers

  def calc_balance history do
    Enum.reduce history, 0, &balance_reducer/2
  end

  def balance_reducer({ :deposit, amount }, acc),  do: acc + amount
  def balance_reducer({ :withdraw, amount }, acc), do: acc - amount
  def balance_reducer(_event, acc),                do: acc
end
