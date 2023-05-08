extends Area2D

class_name Interactable

# Emitted when an interactor starts looking at me
signal focused(interactor: Interactor)

# Emitted when an interactor stops looking at me
signal unfocused(interactor: Interactor)

# Emitted when an interactor interacts with me
signal interacted(interactor: Interactor)

