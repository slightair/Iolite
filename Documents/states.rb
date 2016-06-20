require 'gviz'

Graph do
  add %i(Attack Damaged) => :AgentControlled
  add %i(AgentControlled) => :PreAttack
  add :PreAttack => :Attack
  add %i(AgentControlled) => :Damaged

  rank :same, :PreAttack, :Attack

  save :follower_states, :png
end