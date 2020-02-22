import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var humidityTextField: UITextField!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var feltTemperatureLabel: UILabel!
    @IBOutlet weak var dateAndTimePicker: UIDatePicker!
    
    var windSpeed = 50
    var temperature = 50
    var humidity = 50
    var humidityMode = true
    var history: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load history from user defaults if it exists
        if UserDefaults.standard.array(forKey: "history") != nil {
            history = UserDefaults.standard.array(forKey: "history") as! [String]
        }

        updateDisplay()
    }
    
    // This is for getting rid of the keyboard by touching anywhere else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func windSpeedSlider(_ sender: UISlider) {
        windSpeed = Int(sender.value)
        windSpeedLabel.text = String(windSpeed) + " mph"
        updateDisplay()
    }
    
    @IBAction func temperatureOrHumidityEditingDidEnd(_ sender: Any) {
        updateDisplay()
    }
    
    @IBAction func humidityModeChanged(_ sender: UISwitch) {
        // The action sheet is created
        let action = UIAlertController(title: "Humidity Mode", message: "Do you want to change it?", preferredStyle: .actionSheet)
        
        // The yes action will create an alert
        let yesAction = UIAlertAction(title: "Yes I do.", style: .default, handler: {
            (_: UIAlertAction) -> Void in
            let alert = UIAlertController(title: "Humidity Mode", message: "Is now changed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alert, animated: true, completion: nil)
            self.humidityMode = sender.isOn
            self.updateDisplay()
        })
        
        // The no action will flip the switch back
        let noAction = UIAlertAction(title: "No, I changed my mind!", style: .default, handler: {
            (_: UIAlertAction) -> Void in
            sender.setOn(!sender.isOn, animated: true)
            self.humidityMode = sender.isOn
            self.updateDisplay()
        })
        
        // Add the actions to the action sheet
        action.addAction(yesAction)
        action.addAction(noAction)
        
        // Show the action sheet
        present(action, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Get the time & date from the picker and format it
        let timeAndDate = dateAndTimePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let formattedDate = dateFormatter.string(from: timeAndDate)
        let temperatureReading = formattedDate + ": " + (feltTemperatureLabel.text ?? "")
        
        // If the temp has changed then add the new reading to history
        if history.count != 0 {
            if history[0] != temperatureReading {
                history.insert(temperatureReading, at: 0)
            }
        } else {
            history.insert(temperatureReading, at: 0)
        }
        
        // Save history to user defaults
        UserDefaults.standard.set(history, forKey: "history")
    }
    
    func updateDisplay() {
        // If either is blank it is assumed to be zero
        temperature = Int(temperatureTextField.text ?? "0") ?? 0
        humidity = Int(humidityTextField.text ?? "0") ?? 0
        
        var feltTemperature: Int
        
        // As agreed in class the threshold is 70 degrees
        if temperature < 70 {
            feltTemperature = Int(CalculationsLibrary.windChill(temperature: Double(temperature), velocity: Double(windSpeed)))
        } else if humidityMode {
            feltTemperature = Int(CalculationsLibrary.heatIndex(temperature: Double(temperature), humidity: Double(humidity)))
        } else {
            feltTemperature = temperature
        }
        
        feltTemperatureLabel.text =  CalculationsLibrary.temperatureToEmoji(temperature: feltTemperature) + " " + String(feltTemperature) + " ℉ "
    }
}
