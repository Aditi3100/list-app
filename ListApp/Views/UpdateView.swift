//
//  UpdateView.swift
//  ListApp
//
//  Created by Aditi Nath on 05/01/25.
//

import SwiftUI

struct UpdateView: View {
    @Binding var listName: String
    @Binding var endDate: Date
    @Binding var noEndDate: Bool
    var cancelAction: () -> Void
    var saveAction: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("Edit")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                }
                HStack(spacing: 5) {
                    Text("List Name: ")
                    TextField(listName, text: $listName)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal,10)
                        .overlay{
                            HStack(alignment: .bottom) {
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 1)
                                    .offset(y: 15)
                                    .opacity(0.2)
                            }
                        }
                        .accessibilityHint("Edit list name")
                }
                HStack(alignment: .top, spacing: 5) {
                    Text("Deadline: ")
                    DatePicker(selection: $endDate, in: Date.now..., displayedComponents: .date) {
                        Text("")
                    }
                    .datePickerStyle(.graphical)
                    .disabled(noEndDate)
                    .accessibilityHidden(noEndDate)
                }
                .accessibilityHint(noEndDate ? "List set to have no deadline" : "Select a date for your list's deadline")
                Toggle("No deadline", isOn: $noEndDate)
                    .toggleStyle(CheckToggleStyle())
                    .tint(Color.black)
                    .accessibilityValue(noEndDate ? "No deadline" : "Deadline set")
                    .accessibilityLabel("No deadline")
                    .accessibilityHint("Toggle to set a deadline for your list")
            }
            .padding(16)
            Divider()
            HStack(spacing: 0) {
                Button(role: .destructive, action: cancelAction){
                    Text("Cancel")
                        .multilineTextAlignment(.center)
                }
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Cancel")
                    .accessibilityHint("Double tap to cancel")
                Divider()
                Button(action: saveAction) {
                    Text("Save")
                        .multilineTextAlignment(.center)
                }
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel("Save")
                    .accessibilityHint("Double tap to save changes")
            }
            .frame(height: 50)
        }
    }
}

struct CheckToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {configuration.isOn.toggle()}) {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
            .foregroundStyle(Color.black)
        }
        .buttonStyle(.plain)
    }
}
