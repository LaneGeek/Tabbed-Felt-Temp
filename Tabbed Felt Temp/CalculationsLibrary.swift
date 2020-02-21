import Foundation

class CalculationsLibrary {
    // The wind shield only works for wind speeds above 3mph
    static func windChill(temperature: Double, velocity: Double) -> Double {
        return velocity <= 3 ? temperature : 35.74 + 0.6215 * temperature - 35.75 * pow(velocity, 0.16) + 0.4275 * temperature * pow(velocity, 0.16)
    }
    
    // The heat index
    static func heatIndex(temperature: Double, humidity: Double) -> Double {
        return -42.379 + 2.04901523 * temperature + 10.14333127 * humidity - 0.22475541 * temperature * humidity - 0.00683783 * temperature * temperature - 0.05481717 * humidity * humidity + 0.00122874 * temperature * temperature * humidity + 0.00085282 * temperature * humidity * humidity - 0.00000199 * temperature * temperature * humidity * humidity
    }
    
    // Converts temperature to emoji
    static func temperatureToEmoji(temperature: Int) -> String {
        if temperature < 32 {
            return "🥶"
        } else if temperature < 60 {
            return "😬"
        } else if temperature < 85 {
            return "😃"
        } else if temperature < 100 {
            return "😥"
        } else {
            return "🥵"
        }
    }
}
