//
// Copyright (c) 2020 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import ProgressHUD

//-------------------------------------------------------------------------------------------------------------------------------------------------
@objc protocol RegisterEmailDelegate: class {

	func didRegisterUser()
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
class RegisterEmailView: UIViewController {

	@IBOutlet weak var delegate: RegisterEmailDelegate?

	@IBOutlet var fieldEmail: UITextField!
	@IBOutlet var fieldPassword: UITextField!

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewDidLoad() {

		super.viewDidLoad()

		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		view.addGestureRecognizer(gestureRecognizer)
		gestureRecognizer.cancelsTouchesInView = false
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	override func viewWillDisappear(_ animated: Bool) {

		super.viewWillDisappear(animated)

		dismissKeyboard()
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@objc func dismissKeyboard() {

		view.endEditing(true)
	}

	// MARK: - User actions
	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionDismiss(_ sender: Any) {

		dismiss(animated: true)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	@IBAction func actionRegister(_ sender: Any) {

		let email = (fieldEmail.text ?? "").lowercased()
		let password = fieldPassword.text ?? ""

		if (email.count == 0)		{ ProgressHUD.showError("Please enter your email.");	return }
		if (password.count == 0)	{ ProgressHUD.showError("Please enter your password."); return }

		actionRegister(email: email, password: password)
	}

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func actionRegister(email: String, password: String) {

		ProgressHUD.show(nil, interaction: false)

		AuthUser.signUp(email: email, password: password) { error in
			if let error = error {
				ProgressHUD.showError(error.localizedDescription)
			} else {
				self.createPerson()
			}
		}
	}

	// MARK: -
	//---------------------------------------------------------------------------------------------------------------------------------------------
	func createPerson() {

		let email = (fieldEmail.text ?? "").lowercased()

		let userId = AuthUser.userId()
		Persons.create(userId, email: email)

		self.dismiss(animated: true) {
			self.delegate?.didRegisterUser()
		}
	}
}

// MARK: - UITextFieldDelegate
//-------------------------------------------------------------------------------------------------------------------------------------------------
extension RegisterEmailView: UITextFieldDelegate {

	//---------------------------------------------------------------------------------------------------------------------------------------------
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {

		if (textField == fieldEmail) {
			fieldPassword.becomeFirstResponder()
		}
		if (textField == fieldPassword) {
			actionRegister(0)
		}
		return true
	}
}
