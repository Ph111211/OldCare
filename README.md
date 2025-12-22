# H. Dự án: "An Tâm" – Hệ thống Hỗ trợ Chăm sóc Người cao tuổi
- Đây là dự án môn phát triển ứng dụng cho thiết bị di động của nhóm chúng tôi gồm các thành viên:
    - Phạm Đức Phú
    - Tạ Xuân Phong
    - Nguyễn Thành Long.
# Mô tả thông tin về dự án.
## 1.Tổng quan Dự án (Project Overview) 
"An Tâm" là một hệ thống ứng dụng "ghép cặp" được thiết kế để kết nối con cái (đang đi làm, bận rộn) với cha mẹ lớn tuổi (sống một mình hoặc ở xa). 

Mục tiêu của dự án là giải quyết nỗi lo lắng thường trực của người con ("Không biết bố mẹ ở nhà có ổn không? Đã uống thuốc chưa?") và sự phức tạp về công nghệ đối với người già.

**Hệ thống bao gồm hai ứng dụng:**

1.  "An Tâm - Con" (Cho Người Chăm sóc): Một ứng dụng "trung tâm chỉ huy" để lên lịch, theo dõi, và nhận cảnh báo. 

2.  "An Tâm - Cha Mẹ" (Cho Người cao tuổi): Một ứng dụng cực kỳ đơn giản (với 1-3 nút bấm lớn) để cha mẹ có thể check-in và gọi khẩn cấp mà không cần biết dùng công nghệ. 

## 2.Bối cảnh & Vấn đề (Business Problem & Context) 

**Hiện trạng (Current State):** Ngày càng nhiều người trẻ phải sống và làm việc xa nhà, trong khi cha mẹ họ ngày càng lớn tuổi và cần được quan tâm. 

**1.  Nỗi lo Thường trực (Carer's Anxiety):** 
Người con luôn trong trạng thái lo lắng: </br>
-   "Bố đã uống thuốc huyết áp sáng nay chưa?" 
-   "Mẹ ở nhà một mình, lỡ bị ngã thì sao?" 
-   "Mình bận họp, quên gọi điện nhắc bố mẹ ăn cơm." 

**2. Sự Phức tạp của Công nghệ:** Người lớn tuổi rất ngại công nghệ. Họ thấy Zalo, Messenger, Facebook quá rắc rối. Việc "dạy" họ cách dùng điện thoại thông minh là một gánh nặng.

**3. Quên và Nhầm lẫn:** Người lớn tuổi dễ quên lịch uống thuốc, lịch tái khám. Người con cũng quên nhắc vì quá bận rộn. Hậu quả của việc này có thể rất nghiêm trọng (ví dụ: uống sai thuốc,quên tái khám). 

### Cơ hội (Opportunity): 
Xây dựng một "cầu nối" công nghệ vô hình. Phía người con sẽ xử lý mọi sự phức tạp (lên lịch), và phía cha mẹ chỉ cần thực hiện một hành động duy nhất (ví dụ: bấm một nút lớn) để xác nhận, giúp con cái an tâm ngay lập tức. 
## 3.Đối tượng Người dùng (Target Audience) 
• **Persona 1: "Người Con Bận rộn" (The Carer)** 

-  Mô tả: 30-45 tuổi, đi làm, rành công nghệ, sống xa cha mẹ.

-   Nhu cầu: Cần một cách đáng tin cậy để biết tình trạng của cha mẹ (đặc biệt là việc uống thuốc) mà không cần phải gọi điện 5 lần/ngày.

• **Persona 2: "Người Cha/Mẹ Lớn tuổi" (The Elder)** 
-   Mô tả: 65+ tuổi, sống một mình hoặc với vợ/chồng, không rành công nghệ, dễ quên. 
        
-   Nhu cầu: Cần sự độc lập, không muốn "làm phiền" con cái, và cần một cách cực kỳ đơn giản để gọi trợ giúp khi khẩn cấp. 

## Yêu cầu Chức năng (Functional Requirements - FRs) 
Đây là mô tả các tính năng của hệ thống ghép cặp này. </br>
• **FR1: Module "Thiết lập Lịch trình"** (Dành cho App "Con") </br>
-   FR1.1: Tạo Lịch uống thuốc: Người Con có thể tạo lịch uống thuốc chi tiết cho Cha Mẹ.</br> 
    -   Ví dụ: "Thuốc Huyết áp - 8:00 Sáng - Hàng ngày - 1 viên"
    -   Ví dụ: "Thuốc Tiểu đường - 6:00 Tối - Hàng ngày - 2 viên"</br>
-   FR1.2: Tạo Lịch Hẹn: Người Con nhập các lịch hẹn (ví dụ: "Tái khám Tim mạch - 9:00, Thứ Sáu, 15/11").

• **FR2: Module "Check-in Đơn giản"** (Dành cho App "Cha Mẹ") </br>
-   FR2.1: Giao diện Tối giản: App "Cha Mẹ" chỉ có 3 nút bấm khổng lồ. </br>
    -   FR2.2: Nút "SOS" (Khẩn cấp): Bấm nút này sẽ ngay lập tức gọi điện thoại (cuộc gọi di động, không phải qua app) cho Người Con. </br>
    -   FR2.3: Nút "Check-in": Khi đến giờ uống thuốc (8:00 Sáng), màn hình ứng dụng sẽ sáng lên và phát ra âm báo nhắc nhở, hiển thị nút:

        o   [BẤM VÀO ĐÂY ĐỂ BÁO ĐÃ UỐNG THUỐC] </br>
        o   Cha Mẹ chỉ cần bấm vào nút này để xác nhận.</br> 

    -   FR2.4: Nút "Gọi Con": Một nút để yêu cầu Người Con gọi lại khi rảnh (không khẩn cấp). 

• **FR3: Module "Bảng điều khiển An Tâm"** (Dành cho App "Con")

-   FR3.1: Dashboard Trạng thái: Người Con mở app và thấy ngay lập tức: 

    o "Thuốc Huyết áp Sáng: Đã uống lúc 8:05" </br>
    o "Thuốc Tiểu đường Tối: Chưa uống" </br>

-   FR3.2: Hệ thống Cảnh báo (Alert): Tính năng cốt lõi. </br>
    -   Nếu đến 8:30 Sáng mà Cha Mẹ chưa bấm nút (FR2.3), Người Con sẽ nhận được một thông báo đẩy (push notification): "Cảnh báo! Cha Mẹ chưa xác nhận uống thuốc Huyết áp Sáng." 

-   FR3.3: Nhận Cảnh báo SOS: Khi Cha Mẹ bấm nút "SOS", Người Con nhận được cuộc gọi và thông báo khẩn cấp.

-   FR3.4: Lịch sử Check-in: Xem lại lịch sử tuân thủ uống thuốc của cha mẹ (ví dụ: "Tháng này tuân thủ 90%").

• **FR4: Module "Kết nối Gia đình"** (Tính năng Mở rộng) 
-   FR4.1: Chia sẻ Ảnh đơn giản: Người Con có thể tải ảnh (ảnh cháu) lên. App "Cha Mẹ" sẽ 
tự động hiển thị ảnh đó (dạng slideshow) khi không dùng. (Giúp giảm sự cô đơn). 
## 5.Yêu cầu Phi chức năng (Non-Functional Requirements - NFRs)

-   **NFR1**: Tính Dễ sử dụng & Khả năng Truy cập (Accessibility): Quan trọng tuyệt đối.
    -   App "Cha Mẹ" (FR2) phải tuân thủ các tiêu chuẩn cao nhất: Font chữ cực lớn, độ tương phản cao, hỗ trợ âm thanh (Text-to-Speech) cho mọi nút bấm. </br>
-   **NFR2: Độ Tin cậy (Reliability):** Hệ thống cảnh báo (FR3.2) và nút SOS (FR2.2) phải hoạt động 100% chính xác, ngay cả khi mạng yếu (ví dụ: SOS phải kích hoạt cuộc gọi di động GSM, không phụ thuộc vào data). </br>
-   **NFR3: Cài đặt Tối giản**: Người Con phải là người cài đặt toàn bộ ứng dụng cho Cha Mẹ. Cha Mẹ chỉ cần mở và dùng, không cần đăng nhập, không cần cấu hình. </br>
-   **NFR4: Tối ưu Pin:** Cả hai ứng dụng không được gây tốn pin, đặc biệt là app "Cha Mẹ" (vì người già hay quên sạc). 
## 6.Ràng buộc & Giả định (Constraints & Assumptions) 
-   **Ràng buộc 1** (Lớn nhất): Cha Mẹ phải có một thiết bị (smartphone hoặc máy tính bảng) và thiết bị đó phải được kết nối mạng (Wifi/4G).</br> 
-   **Ràng buộc 2**: Ứng dụng này là một công cụ hỗ trợ, không thay thế các thiết bị y tế chuyên nghiệp hoặc dịch vụ chăm sóc tại chỗ. </br>
-   **Giả định 1**: Người Cha/Mẹ có đủ khả năng nhận thức để hiểu "Bấm nút này khi uống thuốc xong" và "Bấm nút đỏ khi gặp nguy hiểm". </br>
-   **Giả định 2**: Người Con chịu trách nhiệm 100% về tính chính xác của lịch thuốc (FR1.1) được nhập vào hệ thống. 
