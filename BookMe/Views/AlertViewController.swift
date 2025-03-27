import SwiftUI
import Observation

@Observable
class AlertViewController {
    // Alert state properties
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    var primaryButtonText = "OK"
    var secondaryButtonText: String?
    var primaryAction: (() -> Void)?
    var secondaryAction: (() -> Void)?
    
    // MARK: - Alert Configuration Functions
    
    /// Shows a basic alert with a single button
    func showBasicAlert(title: String, message: String, buttonText: String = "OK", action: (() -> Void)? = nil) {
        alertTitle = title
        alertMessage = message
        primaryButtonText = buttonText
        primaryAction = action
        secondaryButtonText = nil
        secondaryAction = nil
        showAlert = true
    }
    
    /// Shows a confirmation alert with two buttons
    func showConfirmationAlert(
        title: String,
        message: String,
        primaryButtonText: String = "OK",
        secondaryButtonText: String = "Cancel",
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        alertTitle = title
        alertMessage = message
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        showAlert = true
    }
    
    /// Shows an error alert with customizable retry option
    func showErrorAlert(
        title: String = "Error",
        message: String,
        retryButtonText: String = "Try Again",
        cancelButtonText: String = "Cancel",
        retryAction: @escaping () -> Void,
        cancelAction: (() -> Void)? = nil
    ) {
        alertTitle = title
        alertMessage = message
        primaryButtonText = retryButtonText
        secondaryButtonText = cancelButtonText
        primaryAction = retryAction
        secondaryAction = cancelAction
        showAlert = true
    }
    
    /// Dismiss the alert
    func dismissAlert() {
        showAlert = false
    }
}

// MARK: - Alert View Modifier
extension View {
    func withAlertController(_ alertController: AlertViewController) -> some View {
        self.modifier(AlertControllerModifier(alertController: alertController))
    }
}

// Custom modifier to handle the alert presentation
struct AlertControllerModifier: ViewModifier {
    @State private var isAlertPresented = false
    var alertController: AlertViewController
    
    func body(content: Content) -> some View {
        content
            .onChange(of: alertController.showAlert) { _, newValue in
                isAlertPresented = newValue
            }
            .alert(
                alertController.alertTitle,
                isPresented: $isAlertPresented,
                actions: {
                    Button(alertController.primaryButtonText) {
                        alertController.primaryAction?()
                        alertController.showAlert = false
                        isAlertPresented = false  // Explicitly set to false
                    }
                    
                    if let secondaryText = alertController.secondaryButtonText {
                        Button(secondaryText, role: .destructive) {
                            alertController.secondaryAction?()
                            alertController.showAlert = false
                            isAlertPresented = false  // Explicitly set to false
                        }
                    }
                },
                message: {
                    Text(alertController.alertMessage)
                }
            )
            .onDisappear {
                // This ensures the controller state is synchronized when alert is dismissed by tapping outside
                if isAlertPresented {
                    alertController.showAlert = false
                    isAlertPresented = false
                }
            }
    }
}

// MARK: - Example Usage
// JANGAN LUPA ADD INI DI AKHIR         .withAlertController(alertController)

struct ContentView: View {
    @State private var alertController = AlertViewController()
    
    func saveWorkoutData() {
        // Your save implementation
        print("Attempting to save workout data...")
    }
    
    func deleteWorkoutData() {
        // Your delete implementation
        print("Deleting workout data...")
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Button("Show Server Error Alert") {
                // Make sure to explicitly set showAlert to false before showing a new alert
                alertController.showAlert = false
                
                // Small delay to ensure state changes are processed
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    alertController.showErrorAlert(
                        title: "Unable to Save Workout Data",
                        message: "The connection to the server was lost.",
                        retryButtonText: "Try Again",
                        cancelButtonText: "Delete",
                        retryAction: saveWorkoutData,
                        cancelAction: deleteWorkoutData
                    )
                }
            }
            
            Button("Show Basic Alert") {
                alertController.showAlert = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    alertController.showBasicAlert(
                        title: "Information",
                        message: "Your workout was recorded successfully!",
                        buttonText: "Great"
                    )
                }
            }
            
            Button("Show Confirmation Alert") {
                alertController.showAlert = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    alertController.showConfirmationAlert(
                        title: "End Workout",
                        message: "Are you sure you want to end your current workout?",
                        primaryButtonText: "Yes, End It",
                        secondaryButtonText: "Continue Workout",
                        primaryAction: {
                            print("Workout ended")
                        },
                        secondaryAction: {
                            print("Workout continued")
                        }
                    )
                }
            }
        }
        .padding()
        .withAlertController(alertController)
    }
}

#Preview {
    ContentView()
}
