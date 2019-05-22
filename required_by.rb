class Eye::Trigger::RequiredBy < Eye::Trigger::Custom
  param :names, [Array], true
  param :wait_timeout, [Numeric], nil, 15.seconds

  def check(transition)
    wait_required_by_process if transition.to_name == :stopping
  end

  private

  def wait_required_by_process
    processes = names.map do |name|
      Eye::Control.find_nearest_process(name, process.group_name_pure, process.app_name)
    end.compact.reject { |p| p.state_name == :unmonitored || p.state_name == :down }

    return if processes.empty?

    processes = Eye::Utils::AliveArray.new(processes)

    res = true

    processes.pmap do |p|
      name = p.name

      res &= process.wait_for_condition(wait_timeout, 0.5) do
        info "wait for #{name} in #{wait_timeout}s until it :down or :unmonitored. now it's #{p.state_name}"
        p.state_name == :down || p.state_name == :unmonitored
      end
    end

    unless res
      warn "#{names} are not transition to :unmonitored"
    end
  end
end

module ProcessDSLRequiredBySupport
  def depend_on(names, opts = {})
    super(names, opts)

    nm = @config[:name]
    names.each do |name|
      parent.process(name) do
        trigger("required_by_#{unique_num}", opts.merge(names: [nm]))
      end
    end
  end
end

Eye::Dsl::ProcessOpts.send(:prepend, ProcessDSLRequiredBySupport)
