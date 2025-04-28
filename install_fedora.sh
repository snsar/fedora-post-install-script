#!/bin/bash
#
# Script cài đặt tự động cho Fedora
# Tự động cài đặt các phần mềm và công cụ cần thiết sau khi cài đặt Fedora
#

# Màu sắc cho terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Vui lòng chạy script với quyền root (sudo)${NC}"
  exit 1
fi

# Hàm hiển thị tiêu đề
print_section() {
  echo -e "\n${BLUE}=== $1 ===${NC}"
}

# Hàm hiển thị thông báo thành công
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Hàm hiển thị thông báo lỗi
print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Hàm hiển thị thông báo cảnh báo
print_warning() {
  echo -e "${YELLOW}! $1${NC}"
}

# Hàm xác nhận từ người dùng
confirm() {
  read -p "$1 (y/n): " response
  case "$response" in
    [yY][eE][sS]|[yY])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

print_section "BẮT ĐẦU CÀI ĐẶT"
echo "Script này sẽ cài đặt các phần mềm và công cụ cần thiết cho Fedora"
echo "Vui lòng đảm bảo máy tính được kết nối internet"

# Cập nhật hệ thống
print_section "CẬP NHẬT HỆ THỐNG"
echo "Đang cập nhật hệ thống..."
dnf update -y
print_success "Cập nhật hệ thống hoàn tất"

# Cài đặt RPM Fusion
print_section "CÀI ĐẶT RPM FUSION REPOSITORIES"
echo "Đang cài đặt RPM Fusion repositories..."
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
print_success "Đã cài đặt RPM Fusion repositories"

# Cài đặt các gói cơ bản
print_section "CÀI ĐẶT CÁC GÓI CƠ BẢN"
echo "Đang cài đặt các gói cơ bản..."
dnf install -y \
  wget \
  curl \
  git \
  neovim \
  htop \
  fastfetch \
  gnome-tweaks \
  unzip \
  p7zip \
  p7zip-plugins \
  unrar \
  zsh 
#   util-linux-user
print_success "Đã cài đặt các gói cơ bản"

# Cài đặt các codec đa phương tiện
# print_section "CÀI ĐẶT CODEC ĐA PHƯƠNG TIỆN"
# echo "Đang cài đặt các codec đa phương tiện..."
# dnf install -y \
#   gstreamer1-plugins-base \
#   gstreamer1-plugins-good \
#   gstreamer1-plugins-bad-free \
#   gstreamer1-plugins-ugly-free \
#   gstreamer1-plugins-bad-free \
#   gstreamer1-plugins-ugly \
#   gstreamer1-plugins-bad \
#   gstreamer1-libav
# dnf group upgrade -y --with-optional Multimedia
# print_success "Đã cài đặt các codec đa phương tiện"

# Cài đặt các trình duyệt web
print_section "CÀI ĐẶT TRÌNH DUYỆT WEB"
if confirm "Bạn có muốn cài đặt Google Chrome không?"; then
  echo "Đang cài đặt Google Chrome..."
  dnf install -y fedora-workstation-repositories
  dnf config-manager --set-enabled google-chrome
  dnf install -y google-chrome-stable
  print_success "Đã cài đặt Google Chrome"
fi

if confirm "Bạn có muốn cài đặt Mozilla Firefox không?"; then
  echo "Đang cài đặt Mozilla Firefox..."
  dnf install -y firefox
  print_success "Đã cài đặt Mozilla Firefox"
fi

if confirm "Bạn có muốn cài đặt Brave Browser không?"; then
  echo "Đang cài đặt Brave Browser..."
  dnf install -y dnf-plugins-core
  dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
  rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  dnf install -y brave-browser
  print_success "Đã cài đặt Brave Browser"
fi

# Cài đặt các công cụ phát triển
print_section "CÀI ĐẶT CÔNG CỤ PHÁT TRIỂN"
if confirm "Bạn có muốn cài đặt các công cụ phát triển không?"; then
  echo "Đang cài đặt các công cụ phát triển..."
  dnf groupinstall -y "Development Tools"
  dnf install -y \
    cmake \
    gcc-c++ \
    make \
    automake \
    autoconf \
    python3-devel \
    python3-pip
  print_success "Đã cài đặt các công cụ phát triển"
fi

# Cài đặt Visual Studio Code
if confirm "Bạn có muốn cài đặt Visual Studio Code không?"; then
  echo "Đang cài đặt Visual Studio Code..."
  rpm --import https://packages.microsoft.com/keys/microsoft.asc
  sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
  dnf install -y code
  print_success "Đã cài đặt Visual Studio Code"
fi

# Cài đặt các ứng dụng văn phòng
print_section "CÀI ĐẶT ỨNG DỤNG VĂN PHÒNG"
if confirm "Bạn có muốn cài đặt LibreOffice không?"; then
  echo "Đang cài đặt LibreOffice..."
  dnf install -y libreoffice
  print_success "Đã cài đặt LibreOffice"
fi

# Cài đặt các ứng dụng đa phương tiện
print_section "CÀI ĐẶT ỨNG DỤNG ĐA PHƯƠNG TIỆN"
if confirm "Bạn có muốn cài đặt VLC không?"; then
  echo "Đang cài đặt VLC..."
  dnf install -y vlc
  print_success "Đã cài đặt VLC"
fi

# Cài đặt Flathub
print_section "CÀI ĐẶT FLATHUB"
if confirm "Bạn có muốn cài đặt Flathub không?"; then
  echo "Đang cài đặt Flathub..."
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  print_success "Đã cài đặt Flathub"
fi

# Cài đặt các ứng dụng từ Flathub
if confirm "Bạn có muốn cài đặt một số ứng dụng phổ biến từ Flathub không?"; then
  if confirm "Cài đặt Spotify?"; then
    flatpak install -y flathub com.spotify.Client
    print_success "Đã cài đặt Spotify"
  fi

  if confirm "Cài đặt Discord?"; then
    flatpak install -y flathub com.discordapp.Discord
    print_success "Đã cài đặt Discord"
  fi

  if confirm "Cài đặt Telegram?"; then
    flatpak install -y flathub org.telegram.desktop
    print_success "Đã cài đặt Telegram"
  fi
fi

# Cài đặt các tiện ích hệ thống
print_section "CÀI ĐẶT TIỆN ÍCH HỆ THỐNG"
if confirm "Bạn có muốn cài đặt TLP (tiết kiệm pin cho laptop) không?"; then
  echo "Đang cài đặt TLP..."
  dnf install -y tlp tlp-rdw
  systemctl enable tlp
  print_success "Đã cài đặt và kích hoạt TLP"
fi

# Cài đặt các font
print_section "CÀI ĐẶT FONT"
if confirm "Bạn có muốn cài đặt các font phổ biến không?"; then
  echo "Đang cài đặt các font phổ biến..."
  dnf install -y \
    google-noto-sans-fonts \
    google-noto-serif-fonts \
    google-noto-sans-mono-fonts \
    google-noto-emoji-fonts \
    dejavu-sans-fonts \
    dejavu-serif-fonts \
    dejavu-sans-mono-fonts
  print_success "Đã cài đặt các font phổ biến"
fi

# Cài đặt Vietnamese input method
if confirm "Bạn có muốn cài đặt bộ gõ tiếng Việt (ibus-bamboo) không?"; then
  echo "Đang cài đặt ibus-bamboo..."
  dnf copr enable -y bamboo/ibus-bamboo
  dnf install -y ibus-bamboo
  print_success "Đã cài đặt ibus-bamboo"
  print_warning "Vui lòng đăng xuất và đăng nhập lại để áp dụng thay đổi"
  print_warning "Sau đó, vào Settings > Keyboard > Input Sources để thêm Vietnamese (Bamboo)"
fi

# Dọn dẹp
print_section "DỌN DẸP HỆ THỐNG"
echo "Đang dọn dẹp hệ thống..."
dnf autoremove -y
dnf clean all
print_success "Đã dọn dẹp hệ thống"

print_section "HOÀN TẤT"
echo "Quá trình cài đặt đã hoàn tất!"
echo "Vui lòng khởi động lại hệ thống để áp dụng tất cả các thay đổi."
if confirm "Bạn có muốn khởi động lại ngay bây giờ không?"; then
  echo "Hệ thống sẽ khởi động lại sau 5 giây..."
  sleep 5
  reboot
fi
