package utils;

import java.util.regex.Pattern;

/**
 * Tiện ích kiểm tra định dạng dữ liệu đầu vào.
 */
public class ValidationUtils {

    // Regex cho Email: chuẩn quốc tế cơ bản
    private static final String EMAIL_REGEX = "^[a-zA-Z0-9_+&*-]+(?:\\.[a-zA-Z0-9_+&*-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,7}$";
    
    // Regex cho Số điện thoại Việt Nam: 
    // Bắt đầu bằng 0 hoặc 84, theo sau là các đầu số 3, 5, 7, 8, 9 và có tổng cộng 10-11 chữ số.
    private static final String PHONE_REGEX = "^(0|84)(3|5|7|8|9)[0-9]{8}$";

    /**
     * Kiểm tra định dạng Email.
     */
    public static boolean isValidEmail(String email) {
        if (email == null || email.isEmpty()) return false;
        return Pattern.compile(EMAIL_REGEX).matcher(email).matches();
    }

    /**
     * Kiểm tra định dạng Số điện thoại Việt Nam.
     */
    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.isEmpty()) return false;
        return Pattern.compile(PHONE_REGEX).matcher(phone).matches();
    }
}
