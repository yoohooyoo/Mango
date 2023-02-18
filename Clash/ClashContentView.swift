import SwiftUI
import NetworkExtension

struct ClashContentView: View {
    
    let core: Binding<Core>
    
    @AppStorage(CFIConstant.tunnelMode, store: .shared) private var tunnelMode  = CFITunnelMode.rule
    @AppStorage(CFIConstant.current,    store: .shared) private var current     = ""
    
    @StateObject private var packetTunnelManager    = PacketTunnelManager(core: .clash)
    @StateObject private var subscribeManager       = CFISubscribeManager()
    @StateObject private var databaseManager        = CFIGEOIPManager()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent {
                        CFISubscribeView(current: $current, subscribeManager: subscribeManager)
                    } label: {
                        Label {
                            Text("订阅")
                        } icon: {
                            CFIIcon(systemName: "doc.plaintext", backgroundColor: .green)
                        }
                    }
                }
                Section {
                    LabeledContent {
                        CFIControlView(packetTunnelManager: packetTunnelManager)
                    } label: {
                        Label {
                            Text("状态")
                        } icon: {
                            CFIIcon(systemName: "link", backgroundColor: .blue)
                        }
                    }
                    LabeledContent {
                        if let status = packetTunnelManager.status, status == .connected {
                            CFIConnectedDurationView()
                        } else {
                            Text("--:--")
                        }
                    } label: {
                        Label {
                            Text("连接时长")
                        } icon: {
                            CFIIcon(systemName: "clock", backgroundColor: .blue)
                        }
                    }
                }
                Section {
                    NavigationLink {
                        CFITunnelModeView(tunnelMode: $tunnelMode)
                    } label: {
                        LabeledContent {
                            Text(tunnelMode.name)
                        } label: {
                            Label {
                                Text("代理模式")
                            } icon: {
                                CFIIcon(systemName: "arrow.uturn.right", backgroundColor: .teal)
                            }
                        }
                    }
                    LabeledContent {
                        CFIPolicyGroupView(tunnelMode: tunnelMode)
                    } label: {
                        Label {
                            Text("策略组")
                        } icon: {
                            CFIIcon(systemName: "square.3.layers.3d", backgroundColor: .teal)
                        }
                    }
                }
                Section {
                    NavigationLink {
                        CFISettingView(core: core)
                    } label: {
                        Label {
                            Text("设置")
                        } icon: {
                            CFIIcon(systemName: "gearshape", backgroundColor: .blue)
                        }
                    }
                }
            }
            
            .formStyle(.grouped)
            .navigationTitle(Text("Clash"))
            .onChange(of: tunnelMode) { newValue in
                packetTunnelManager.set(tunnelMode: newValue)
            }
            .onChange(of: current) { newValue in
                packetTunnelManager.set(subscribe: newValue)
            }
        }
    }
}
