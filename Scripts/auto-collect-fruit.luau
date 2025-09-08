local a=game:GetService("Players")
local b=game:GetService("TweenService")
local c=a.LocalPlayer
local d=Instance.new("ScreenGui",c:WaitForChild("PlayerGui"))
d.ResetOnSpawn=false
local e=Instance.new("Frame")
e.Size=UDim2.new(0,300,0,200)
e.Position=UDim2.new(0.3,0,0.3,0)
e.BackgroundColor3=Color3.fromRGB(0,0,0)
e.BorderSizePixel=4
e.BorderColor3=Color3.fromRGB(255,0,0)
e.Parent=d
local function f(g,h)
 local i=Instance.new("TextButton")
 i.Size=UDim2.new(0,260,0,40)
 i.Position=h
 i.BackgroundColor3=Color3.fromRGB(0,0,0)
 i.BorderSizePixel=4
 i.BorderColor3=Color3.fromRGB(255,0,0)
 i.Text=g
 i.TextColor3=Color3.fromRGB(255,0,0)
 i.Font=Enum.Font.SourceSansBold
 i.TextScaled=true
 i.Parent=e
 return i
end
local j=f("Auto coletar fruta",UDim2.new(0,20,0,60))
local k=f("Esp fruta",UDim2.new(0,20,0,120))
local l=false
j.MouseButton1Click:Connect(function()
 l=not l
 j.Text=l and"Auto coletar: ON"or"Auto coletar: OFF"
 while l do
  task.wait(1)
  for _,m in pairs(workspace:GetChildren())do
   if m:IsA("Tool")and m:FindFirstChild("Handle")then
    local n=c.Character and c.Character:FindFirstChild("HumanoidRootPart")
    if n then b:Create(n,TweenInfo.new(4,Enum.EasingStyle.Linear),{CFrame=m.Handle.CFrame}):Play()end
   end
  end
 end
end)
local o=false
k.MouseButton1Click:Connect(function()
 o=not o
 k.Text=o and"ESP: ON"or"ESP: OFF"
 if o then
  for _,p in pairs(workspace:GetChildren())do
   if p:IsA("Tool")and p:FindFirstChild("Handle")then
    local q=Instance.new("Highlight")
    q.Adornee=p.Handle
    q.FillTransparency=1
    q.OutlineColor=Color3.fromRGB(255,0,0)
    q.OutlineTransparency=0
    q.Parent=p
   end
  end
 else
  for _,r in pairs(workspace:GetChildren())do
   if r:FindFirstChild("Highlight")then r.Highlight:Destroy()end
  end
 end
end)
e.Active=true
e.Draggable=true
