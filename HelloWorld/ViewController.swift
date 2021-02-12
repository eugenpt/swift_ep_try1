//
//  ViewController.swift
//  HelloWorld
//
//  Created by ep on 09.02.2021.
//

import UIKit

func levDis(_ w1: String, _ w2: String) -> Int {
    let empty = [Int](repeating:0, count: w2.count)
    var last = [Int](0...w2.count)

    for (i, char1) in w1.enumerated() {
        var cur = [i + 1] + empty
        for (j, char2) in w2.enumerated() {
            cur[j + 1] = char1 == char2 ? last[j] : min(last[j], last[j + 1], cur[j]) + 1
        }
        last = cur
    }
    return last.last!
}

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
    
    @IBOutlet weak var labelLabelBorder: UILabel!
    @IBOutlet weak var switchLabelBorder: UISwitch!
    @IBOutlet weak var lblLengthText: UILabel!
    
    var NSUccessInARow : Int = 0;
    var NFailuresInARow : Int = 0;
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stepperLength.value = Double(globalVars.Length);
        
        theSlider.value = globalVars.Duration;

        switchManual.isOn = globalVars.Manual;
        
        switchLabelBorder.isOn = globalVars.labelBorder;
        
        showHideManual();
        
        let dbltap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        dbltap.numberOfTapsRequired = 2
        view.addGestureRecognizer(dbltap)

        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        textInput.text = "";
        textInput.layer.cornerRadius = 20;
        textInput.layer.masksToBounds = true;
        
        //upLabel.layer.borderWidth = 2.0
        //upLabel.layer.cornerRadius = 8
        upLabel.text = "";
        upLabel.isHidden = false;
        
        
        onStepperValueChanged(self);
        onSliderValueChanged(self);
        
    }
    var realValue : String = "";
    var is_fullscreen : Bool = true;
    @objc func doubleTapped() {
        is_fullscreen = !is_fullscreen;
        
        self.setNeedsStatusBarAppearanceUpdate();
    }
    override var prefersStatusBarHidden: Bool {
        return is_fullscreen
    }
    override func viewWillAppear(_ animated: Bool) {
        //
    }
    
    func updateGlobals(){
        globalVars.Length = Int(stepperLength.value);
        
        globalVars.Duration = theSlider.value;

        globalVars.Manual = switchManual.isOn;
        
        globalVars.labelBorder = switchLabelBorder.isOn;
    }
    
    func showHideManual(){
        theSlider.isHidden = !switchManual.isOn;
        lblLength.isHidden = !switchManual.isOn;
        lblLengthText.isHidden = !switchManual.isOn;
        lblSliderValue.isHidden = !switchManual.isOn;
        stepperLength.isHidden = !switchManual.isOn;
        switchLabelBorder.isHidden = !switchManual.isOn;
        labelLabelBorder.isHidden = !switchManual.isOn;

    }
        
    func Run(){
        textInput.isHidden = false;
        
        textInput.text = "";
        textInput.textColor = UIColor.systemBlue;
        textInput.layer.borderWidth = 0;
        textInput.layer.borderColor = (UIColor.black).cgColor;

        //upLabel.isHidden = true;
        upLabel.text = "";
        
        btnRight.isEnabled = false;
        let randomInt = Int.random(in: Int(pow(10,stepperLength.value-1))..<Int(pow(10,stepperLength.value)));
        realValue = String(randomInt);
//        upLabel.text = String(randomInt);
        
        
        if(switchLabelBorder.isOn){
        upLabel.layer.borderWidth = 1;
            upLabel.layer.borderColor = (UIColor.systemFill).cgColor;
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in:0.5..<1.5)) {
//            self.upLabel.isHidden = false;
            self.upLabel.text = self.realValue;//String(randomInt);
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(self.theSlider.value)) {
//                self.upLabel.isHidden = true;
                self.upLabel.layer.borderWidth = 0;

                self.upLabel.text = "";
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
            //upLabel.isHidden = false;
            upLabel.text = realValue;
            textInput.layer.borderWidth = 3;
            
            if(textInput.text == realValue){
                NFailuresInARow = 0;
                NSUccessInARow += 1;
                
                if((NSUccessInARow > 3) && (!switchManual.isOn)){
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
            }else if(levDis(textInput.text!, realValue) == 1){
                textInput.textColor = UIColor.systemOrange;
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
                
            }
            textInput.layer.borderColor = (textInput.textColor!).cgColor;
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.Run();
            }
        }else{
            Run();
        }
    }
    
    @IBAction func onTextInputValueChanged(_ sender: Any) {
        // auto-"GO" when all OK
        if(textInput.text == realValue){
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
        if(textInput.text == realValue){
            Check();
        }
    }
    @IBAction func onSwithcManualValueChanged(_ sender: Any) {
        globalVars.Manual = switchManual.isOn;
        
        lblManual.isEnabled = switchManual.isOn;
        
        showHideManual();
        
        updateGlobals();

    }
    @IBAction func onLabelBorderChange(_ sender: Any) {
        updateGlobals();
    }
    @IBAction func onTextInputEditingChanged(_ sender: Any) {
        // auto-"GO" when all OK
        if(textInput.text == realValue){
            Check();
        }
    }
}

