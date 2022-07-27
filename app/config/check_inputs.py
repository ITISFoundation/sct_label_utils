import os, time
import tkinter as tk
import argparse

INPUT_FILE = os.path.join(os.environ["DY_SIDECAR_PATH_INPUTS"], "input_1/input_image.nii.gz")
INPUT_LABELS = os.path.join(os.environ["DY_SIDECAR_PATH_INPUTS"], "input_2/labels.txt")

def check_inputs() -> None:
    while not os.path.exists(INPUT_FILE):
        window = tk.Tk(className="sct_label_utils - Check Inputs")
        #window.geometry("500x200")
        text = tk.Label(text=
'''
Please provide the required inputs:
  - image file in first input port
  - txt file containg the labels in the second input port
After that, close this window.
''', font=("Arial", 15), anchor=tk.W, justify="left")
        text.pack()
        window.mainloop()
        time.sleep(1)

    while not os.path.exists(INPUT_LABELS):
        window = tk.Tk(className="sct_label_utils - Check Inputs")
        #window.geometry("500x200")
        text = tk.Label(text=
'''
Please provide txt file containg the labels in the second input port.
After that, close this window.
''', font=("Arial", 15), anchor=tk.W, justify="left")
        text.pack()
        window.mainloop()
        time.sleep(1)

def message_user() -> None:
    window = tk.Tk(className="Labeling completed - do you want to re-run?")
    #window.geometry("500x200")
    text = tk.Label(text=
'''
Labelling completed, you will find the labelled image in the output port. 
To start a new labelling task, disconnect and re-connect the inputs.
After that, close this window.
''', font=("Arial", 15), anchor=tk.W, justify="left")
    text.pack()
    window.mainloop()

def main() -> None:
    parser = argparse.ArgumentParser(description="Check inputs for service")
    parser.add_argument("--re_run", action="store_true", help="Ask the user to connect new inputs to re-run")
    args = parser.parse_args()

    if args.re_run:
        message_user()
        check_inputs()
    else:
        check_inputs()


if __name__ == "__main__":
    main()