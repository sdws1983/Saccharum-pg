import argparse
import numpy as np
from scipy.optimize import curve_fit

def func(x, a1, a2, a3):
    """拟合函数: y = (a1 * x) / (x + a2) + a3"""
    return (a1 * x) / (x + a2) + a3

def saturation_x(fraction, a1, a2, a3, L):
    """计算达到指定比例饱和所需的样本数 x"""
    target = fraction * L
    return (target - a3) * a2 / (a1 - (target - a3))

def get_initial_guess(x_data, y_data):
    """根据数据范围自动设置初始猜测"""
    y_min = np.min(y_data)
    y_max = np.max(y_data)
    a3_guess = y_min * 0.9
    a1_guess = (y_max - y_min) * 1.2
    a2_guess = len(x_data) / 4 
    return [a1_guess, a2_guess, a3_guess]

def main():
    parser = argparse.ArgumentParser(description="Fit pangenome data with y = (a1 * x)/(x + a2) + a3")
    parser.add_argument('input_file', type=str, help='Path to input file with one number per line')
    args = parser.parse_args()

    try:
        with open(args.input_file, 'r') as f:
            y_data = [float(line.strip()) for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: File '{args.input_file}' not found.")
        return
    except ValueError:
        print("Error: File contains invalid data. Each line must be a number.")
        return

    y_data = np.array(y_data)
    x_data = np.arange(1, len(y_data) + 1)

    initial_guess = get_initial_guess(x_data, y_data)

    try:
        popt, pcov = curve_fit(func, x_data, y_data, p0=initial_guess, maxfev=10000)
    except RuntimeError:
        print("Error: Fitting failed. Try adjusting initial guess or check data.")
        return

    a1, a2, a3 = popt

    y_fit = func(x_data, *popt)
    ss_res = np.sum((y_data - y_fit)**2)
    ss_tot = np.sum((y_data - np.mean(y_data))**2)
    r_squared = 1 - (ss_res / ss_tot) if ss_tot > 0 else float('nan')

    L = a1 + a3

    x_95 = saturation_x(0.95, a1, a2, a3, L)
    x_99 = saturation_x(0.99, a1, a2, a3, L)

    one_sample_actual = y_data[0] / L if L != 0 else float('nan')
    one_sample_fitted = func(1, *popt) / L if L != 0 else float('nan')
    full_actual = y_data[-1] / L if L != 0 else float('nan')
    full_fitted = func(len(x_data), *popt) / L if L != 0 else float('nan')
    samples_100_fitted = func(100, *popt) / L if L != 0 else float('nan')

    print("Fitted parameters:")
    print(f"  a1 = {a1:.2f}")
    print(f"  a2 = {a2:.2f}")
    print(f"  a3 = {a3:.2f}")
    print(f"R-squared = {r_squared:.4f}")
    print(f"Saturated gene total (L) = {L:.2f}")
    print("for growth curve, We fund that")
    print(f"Samples for 95% saturation = {x_95:.2f}")
    print(f"Samples for 99% saturation = {x_99:.2f}")
    print("in practicel")
    print(f"One sample actual / L = {one_sample_actual:.4f}")
    print(f"One sample fitted / L = {one_sample_fitted:.4f}")
    print(f"{len(x_data)} samples actual / L = {full_actual:.4f}")
    print(f"{len(x_data)} samples fitted / L = {full_fitted:.4f}")
    print(f"100 samples fitted / L = {samples_100_fitted:.4f}")

if __name__ == "__main__":
    main()
