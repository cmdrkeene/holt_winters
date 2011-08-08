#  Given a time series, say a complete monthly data for 12 months, the Holt-Winters smoothing and forecasting
#  technique is built on the following formulae (multiplicative version):
#
#  St[i] = alpha * y[i] / It[i - period] + (1.0 - alpha) * (St[i - 1] + Bt[i - 1])
#  Bt[i] = gamma * (St[i] - St[i - 1]) + (1 - gamma) * Bt[i - 1]
#  It[i] = beta * y[i] / St[i] + (1.0 - beta) * It[i - period]
#  Ft[i + m] = (St[i] + (m * Bt[i])) * It[i - period + m]
#
#  Note: Many authors suggest calculating initial values of St, Bt and It in a variety of ways, but
#  some of them are incorrect e.g. determination of It parameter using regression. I have used
#  the NIST recommended methods.
#
#  For more details, see:
#  http://adorio-research.org/wordpress/?p=1230
#  http://www.itl.nist.gov/div898/handbook/pmc/section4/pmc435.htm
#
module HoltWinters
  class << self
    #  This method is the entry point. It calculates the initial values and returns the forecast
    #  for the m periods.
    #
    #  y - Time series data.
    #  alpha - Exponential smoothing coefficients for level
    #  beta - Exponential smoothing coefficients for trend (increasing beta tightens fit)
    #  gamma - Exponential smoothing coefficients for seasonal
    #  period - A complete season's data consists of L periods. And we need
    #    to estimate the trend factor from one period to the next. To
    #    accomplish this, it is advisable to use two complete seasons;
    #    that is, 2L periods.
    #
    #  m - Extrapolated future data points.
    #    4 quarterly
    #    7 weekly.
    #    12 monthly
    def forecast(y, alpha, beta, gamma, period, m)
      return nil if y.empty?

      seasons = y.size / period
      a0 = calculateInitialLevel(y, period)
      b0 = calculateInitialTrend(y, period)

      seasonal_indices = calculateSeasonalIndices(y, period, seasons)

      calculateHoltWinters(y, a0, b0, alpha, beta, gamma, seasonal_indices, period, m);
    end

    def calculateHoltWinters(y, a0, b0, alpha, beta, gamma, seasonal_indicies, period, m)
      st = Array.new(y.length, 0.0)
      bt = Array.new(y.length, 0.0)
      it = Array.new(y.length, 0.0)
      ft = Array.new(y.length + m, 0.0)

      st[1] = a0
      bt[1] = b0

      (0..period - 1).each do |i|
        it[i] = seasonal_indicies[i]
      end

      ft[m] = (st[0] + (m * bt[0])) * it[0] # This is actually 0 since bt[0] = 0
      ft[m + 1] = (st[1] + (m * bt[1])) * it[1] # Forecast starts from period + 2

      (2..(y.size - 1)).each do |i|
        # Calculate overall smoothing
        if (i - period) >= 0
         st[i] = alpha * y[i] / it[i - period] + (1.0 - alpha) * (st[i - 1] + bt[i - 1])
        else
          st[i] = alpha * y[i] + (1.0 - alpha) * (st[i - 1] + bt[i - 1])
        end

        # Calculate trend smoothing
        bt[i] = gamma * (st[i] - st[i - 1]) + (1 - gamma) * bt[i - 1]

        # Calculate seasonal smoothing
        if (i - period) >= 0
          it[i] = beta * y[i] / st[i] + (1.0 - beta) * it[i - period]
        end

        # Calculate forecast
        if (i + m) >= period
          ft[i + m] = (st[i] + (m * bt[i])) * it[i - period + m]
        end
      end

      ft
    end

    # See: http://robjhyndman.com/researchtips/hw-initialization/
    # 1st period's average can be taken. But y[0] works better.
    def calculateInitialLevel(y, period)
      y.first
    end


    # See: http://www.itl.nist.gov/div898/handbook/pmc/section4/pmc435.htm
    def calculateInitialTrend(y, period)
      sum = 0

      (0..period - 1).each do |i|
        sum += (y[period + i] - y[i])
      end

      sum / (period * period)
    end


    # See: http://www.itl.nist.gov/div898/handbook/pmc/section4/pmc435.htm
    def calculateSeasonalIndices(y, period, seasons)
      seasonalAverage = Array.new(seasons, 0.0)
      seasonalIndices = Array.new(period, 0.0)
      averagedObservations = Array.new(y.size, 0.0)

      (0..seasons - 1).each do |i|
        (0..period - 1).each do |j|
          seasonalAverage[i] += y[(i * period) + j]
        end
        seasonalAverage[i] /= period
      end

      (0..seasons - 1).each do |i|
        (0..period - 1).each do |j|
          averagedObservations[(i * period) + j] = y[(i * period) + j] / seasonalAverage[i]
        end
      end

      (0..period - 1).each do |i|
        (0..seasons - 1).each do |j|
          seasonalIndices[i] += averagedObservations[(j * period) + i]
        end
        seasonalIndices[i] /= seasons
      end

      seasonalIndices
    end
  end
end
