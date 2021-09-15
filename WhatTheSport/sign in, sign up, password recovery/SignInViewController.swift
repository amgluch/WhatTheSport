

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    var emailField: UITextField!
    var passwordField: UITextField!
    var signInButton: UIButton!
    var constraint: NSLayoutConstraint!
    var forgotPassword: UILabel!
    var logo: UIImageView!
    var signUpVC: SignUpViewController!
    var forgotButton: UIButton!
    var forgotVC: ForgotPasswordViewController!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var constraints: [NSLayoutConstraint] = []
        
        view.backgroundColor = UIColor(rgb: Constants.Colors.lightOrange)
        self.title = "Sign In"
        
        logo = UIImageView(frame: .zero)
        logo.image = UIImage(named: "splash")
        self.view.addSubview(logo)
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor))
        constraints.append(logo.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(logo.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(logo.heightAnchor.constraint(equalToConstant: 125))
        
        emailField = TextField(placeholder: "Email")
        self.view.addSubview(emailField)
        
        emailField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(emailField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 125))
        constraints.append(emailField.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor))
        constraints.append(emailField.widthAnchor.constraint(equalToConstant: view.bounds.width-50))
        constraints.append(emailField.heightAnchor.constraint(equalToConstant: Constants.Field.height))
        
        passwordField = SecureTextField(placeholder: "Password")
        passwordField.delegate = self
        self.view.addSubview(passwordField)
        
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(passwordField.centerXAnchor.constraint(equalTo: emailField.centerXAnchor))
        constraints.append(passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: Constants.Field.spacing))
        constraints.append(passwordField.widthAnchor.constraint(equalTo: emailField.widthAnchor))
        constraints.append(passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
//        forgotPassword = UILabel(frame: .zero)
//        forgotPassword.textColor = .blue
//        forgotPassword.attributedText = NSAttributedString(string: "Forgot Password?", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
//        forgotPassword.textAlignment = .center
//        self.view.addSubview(forgotPassword)
//
//        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
//        constraints.append(forgotPassword.centerXAnchor.constraint(equalTo: passwordField.centerXAnchor))
//        constraints.append(forgotPassword.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Constants.Field.spacing))
//        constraints.append(forgotPassword.widthAnchor.constraint(equalTo: emailField.widthAnchor))
//        constraints.append(forgotPassword.heightAnchor.constraint(equalTo: emailField.heightAnchor))
        
        forgotButton = LinkButton(title: "Forgot Password?")
        forgotButton.addTarget(self, action: #selector(forgotPress), for: .touchUpInside)
        self.view.addSubview(forgotButton)
        
        forgotButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(forgotButton.centerXAnchor.constraint(equalTo: passwordField.centerXAnchor))
        constraints.append(forgotButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: Constants.Field.spacing * 1.75))
        constraints.append(forgotButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor, multiplier: 0.8))
        constraints.append(forgotButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor))
        
        signInButton = Button(title: "Sign In")
        signInButton.addTarget(self, action: #selector(signInPress), for: .touchUpInside)
        self.view.addSubview(signInButton)
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        constraints.append(signInButton.centerXAnchor.constraint(equalTo: forgotButton.centerXAnchor))
        constraints.append(signInButton.topAnchor.constraint(equalTo: forgotButton.bottomAnchor, constant: Constants.Field.spacing * 1.75))
        constraints.append(signInButton.widthAnchor.constraint(equalTo: passwordField.widthAnchor))
        constraints.append(signInButton.heightAnchor.constraint(equalTo: passwordField.heightAnchor))
        
        NSLayoutConstraint.activate(constraints)
    }
    override func viewWillAppear(_ animated: Bool) {
        inTransition = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == self.passwordField) {
            textField.isSecureTextEntry = true
        }
    }

    @objc func signInPress(sender: UIButton!) {
        guard let email = emailField.text,
              let password = passwordField.text,
              email.count > 0,
              password.count > 0
        else {
            let controller = UI.createAlert(title: "Error", msg: "fields must not be blank")
            self.present(controller, animated: true, completion: nil)
            return
        }
        let delegate = signUpVC! as Transitioner
        delegate.signIn(email: email, password: password)
    }
    
    @objc func forgotPress(sender: UIButton!) {
        if inTransition {
            return
        } else {
            inTransition = true
        }
        if forgotVC == nil {
            forgotVC = ForgotPasswordViewController()
        }
        
        UI.transition(dest: forgotVC, src: self)
    }
}

