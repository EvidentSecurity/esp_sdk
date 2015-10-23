module ESP::StatTotals # :nodoc:
  # We only add new_1w* and old* fields as the new_1w field includes the counts from new_1h and new_1d.
  def total
    attributes.select { |a, _v| a.match(/new_1w|old/) }.values.reduce(:+)
  end

  def total_suppressed
    attributes.select { |a, _v| a.match(/suppressed_/) }.values.reduce(:+)
  end

  %w(fail warn error pass info).each do |status|
    # Defines the following methods:
    #   Stat#total_pass
    #   Stat#total_fail
    #   Stat#total_warn
    #   Stat#total_error
    #   Stat#total_info
    define_method "total_#{status}" do
      attributes.select { |a, _v| a.match(/new_1w|old/) && a.match(/#{status}/) }.values.reduce(:+)
    end

    # Defines the following methods:
    #   Stat#total_new_1h_pass
    #   Stat#total_new_1h_fail
    #   Stat#total_new_1h_warn
    #   Stat#total_new_1h_error
    #   Stat#total_new_1h_info
    #   Stat#total_new_1d_pass
    #   Stat#total_new_1d_fail
    #   Stat#total_new_1d_warn
    #   Stat#total_new_1d_error
    #   Stat#total_new_1d_info
    #   Stat#total_new_1w_pass
    #   Stat#total_new_1w_fail
    #   Stat#total_new_1w_error
    #   Stat#total_new_1w_info
    #   Stat#total_new_1w_warn
    #   Stat#total_old_fail
    #   Stat#total_old_pass
    #   Stat#total_old_warn
    #   Stat#total_old_error
    #   Stat#total_old_info
    %w(new_1h new_1d new_1w old).each do |time|
      define_method "total_#{time}_#{status}" do
        attributes.select { |a| a.match(/#{time}/) && a.match(/#{status}/) }.values.reduce(:+)
      end
    end

    # Defines the following methods:
    #   Stat#total_suppressed_pass
    #   Stat#total_suppressed_fail
    #   Stat#total_suppressed_warn
    #   Stat#total_suppressed_error
    define_method "total_suppressed_#{status}" do
      attributes.select { |a| a.match(/suppressed_/) && a.match(/#{status}/) }.values.reduce(:+)
    end
  end

  # Defines the following methods:
  #   Stat#total_new_1h
  #   Stat#total_new_1d
  #   Stat#total_new_1w
  #   Stat#total_old
  %w(new_1h new_1d new_1w old).each do |time|
    define_method "total_#{time}" do
      attributes.select { |a| a.match(/#{time}/) }.values.reduce(:+)
    end
  end
end
