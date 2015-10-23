module ESP
  class Stat
    class Region < ESP::Resource
      include ESP::StatTotals

      # :section: 'total' rollup methods

      # :method: total

      # :method: total_pass

      # :method: total_fail

      # :method: total_warn

      # :method: total_error

      # :method: total_info

      # :method: total_new_1h_pass

      # :method: total_new_1h_fail

      # :method: total_new_1h_warn

      # :method: total_new_1h_error

      # :method: total_new_1h_info

      # :method: total_new_1d_pass

      # :method: total_new_1d_fail

      # :method: total_new_1d_warn

      # :method: total_new_1d_error

      # :method: total_new_1d_info

      # :method: total_new_1w_pass

      # :method: total_new_1w_fail

      # :method: total_new_1w_error

      # :method: total_new_1w_info

      # :method: total_new_1w_warn

      # :method: total_old_fail

      # :method: total_old_pass

      # :method: total_old_warn

      # :method: total_old_error

      # :method: total_old_info

      # :method: total_suppressed

      # :method: total_suppressed_pass

      # :method: total_suppressed_fail

      # :method: total_suppressed_warn

      # :method: total_suppressed_error

      # :method: total_new_1h

      # :method: total_new_1d

      # :method: total_new_1w

      # :method: total_old
    end
  end
end
