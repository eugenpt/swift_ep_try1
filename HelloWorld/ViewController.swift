//
//  ViewController.swift
//  HelloWorld
//
//  Created by ep on 09.02.2021.
//

import UIKit


class ViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var theSlider: UISlider!
    @IBOutlet weak var lblSliderValue: UILabel!
    @IBOutlet weak var btnRight: UIButton!
    
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var lblLength: UILabel!
    //    var theInt:Int;
    @IBOutlet weak var stepperLength: UIStepper!
    @IBOutlet weak var switchManual: UISwitch!
    @IBOutlet weak var lblManual: UILabel!
    
    @IBOutlet weak var lblLengthText: UILabel!
    
    var NSUccessInARow : Int = 0;
    var NFailuresInARow : Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepperLength.value = Double(globalVars.Length);
        
        theSlider.value = globalVars.Duration;

        switchManual.isOn = globalVars.Manual;
        
        
        showHideManual();
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        onStepperValueChanged(self);
        onSliderValueChanged(self);
    }
    
    func updateGlobals(){
        globalVars.Length = Int(stepperLength.value);
        
        globalVars.Duration = theSlider.value;

        globalVars.Manual = switchManual.isOn;
    }
    
    func showHideManual(){
        theSlider.isHidden = !switchManual.isOn;
        lblLength.isHidden = !switchManual.isOn;
        lblLengthText.isHidden = !switchManual.isOn;
        lblSliderValue.isHidden = !switchManual.isOn;
        stepperLength.isHidden = !switchManual.isOn;

    }
        
    func Run(){
        textInput.isHidden = false;
        
        textInput.text = "";
        textInput.textColor = UIColor.systemBlue;
        textInput.layer.borderWidth = 1;
        textInput.layer.borderColor = (UIColor.black).cgColor;

        upLabel.isHidden = true;
        
        btnRight.isEnabled = false;
        let randomInt = Int.random(in: Int(pow(10,stepperLength.value-1))..<Int(pow(10,stepperLength.value)));
        upLabel.text = String(randomInt);
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in:0.5..<1.5)) {
            self.upLabel.isHidden = false;
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.theSlider.value)) {
                self.upLabel.isHidden = true;
                self.btnRight.isEnabled = true;
                self.textInput.becomeFirstResponder();
            }
        }
    }
    
    //MARK: Actions
    @IBAction func onSliderValueChanged(_ sender: Any) {
        lblSliderValue.text = String(Int(theSlider.value * 1000)) + " ms";
        updateGlobals();
    }
    
    func Check(){
        if(textInput.text != ""){
            upLabel.isHidden = false;
            textInput.layer.borderWidth = 3;
            if(textInput.text == upLabel.text){
                NFailuresInARow = 0;
                NSUccessInARow += 1;
                
                if((NSUccessInARow > 3)                   && (!switchManual.isOn)){
                    NSUccessInARow = 0;
                    // make things harder
                    if(theSlider.value < 0.15){
                        theSlider.value = 0.5;
                        stepperLength.value += 1;
                        onStepperValueChanged(Check);
                    }else{
                        theSlider.value *= 0.8;
                    }
                    onSliderValueChanged(self);
                    //updateGlobals();
                }
                
                textInput.textColor = UIColor.systemGreen;
                textInput.layer.borderColor = (UIColor.systemGreen).cgColor;
            }else{
                NSUccessInARow = 0;
                NFailuresInARow += 1;
                
                if((NFailuresInARow > 3) && (!switchManual.isOn)){
                    NFailuresInARow = 0;
                    // make things easier
                    if(theSlider.value > 0.7){
                        theSlider.value = 0.3;
                        stepperLength.value -= 1;
                        onStepperValueChanged(self);
                    }else{
                        theSlider.value *= 1.2;
                    }
                    onSliderValueChanged(self);
                }
                
                textInput.textColor = UIColor.systemRed;
                textInput.layer.borderColor = (UIColor.systemRed).cgColor;
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.Run();
            }
        }else{
            Run();
        }
    }
    
    @IBAction func onTextInputValueChanged(_ sender: Any) {
        // auto-"GO" when all OK
        if(textInput.text == upLabel.text){
            Check();
        }
    }
    @IBAction func rightBtnAction(_ sender: Any) {
        
        Check();
        
    }
 
    @IBAction func bottomBtnAction(_ sender: Any) {
    }
    @IBAction func onStepperValueChanged(_ sender: Any) {
        lblLength.text = String(Int(stepperLength.value));
        updateGlobals();
    }
    @IBAction func onIntputTextEditEnd(_ sender: Any) {
        // auto-"GO" when all OK
        if(textInput.text == upLabel.text){
            Check();
        }
    }
    @IBAction func onSwithcManualValueChanged(_ sender: Any) {
        globalVars.Manual = switchManual.isOn;
        
        lblManual.isEnabled = switchManual.isOn;
        
        showHideManual();
        
        updateGlobals();

    }
    @IBAction func onTextInputEditingChanged(_ sender: Any) {
        // auto-"GO" when all OK
        if(textInput.text == upLabel.text){
            Check();
        }
    }
}

